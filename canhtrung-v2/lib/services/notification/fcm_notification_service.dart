import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ovumb_app_version1/data/enum/notification_enum.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/auth_v2/auth_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/notification/notification_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order_v2/order_v2_repository.dart';
import 'package:flutter_ovumb_app_version1/main.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/reminder/reminder_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_circle.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_discount_product.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/services/exception.dart';
import 'package:permission_handler/permission_handler.dart';

class FcmNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _prefs = SharedPreferencesService();

  static const _androidChannel = AndroidNotificationChannel(
    'ovumb_id',
    'ovumb',
    'ovumb_noticafication',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('ovumb'),
  );

  initNotifications() async {
    await _messaging.requestPermission();
    String? fcm = await _messaging.getToken();
    print('fcm $fcm');
    _prefs.setFCM(fcm ?? '');
    await initPushNotification();
  }

  //register topic
  registerTopic(PhaseEnum phaseEnum) async {
    final deviceToken = _prefs.deviceToken;
    if (deviceToken == null) {
      initNotifications();
    }
    if (deviceToken != null && deviceToken != 'updated') {
      final res = await AuthRepositoryV2().updateDeviceToken();
      if (res.isOk) {
        _prefs.setFCM('updated');
      }
    }
    await _messaging.subscribeToTopic(PhaseEnum.none.toInt().toString());
    if (Platform.isIOS) {
      String? apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        await _messaging.subscribeToTopic(phaseEnum.toInt().toString());
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          await _messaging.subscribeToTopic(phaseEnum.toInt().toString());
        }
      }
    } else {
      await _messaging.subscribeToTopic(phaseEnum.toInt().toString());
    }
  }

  Future initPushNotification() async {
    try {
      await _messaging.setForegroundNotificationPresentationOptions(
        sound: true,
        badge: true,
        alert: true,
      );
      _messaging.getInitialMessage().then((message) =>
          Future.delayed(const Duration(seconds: 1))
              .then((value) => handleMessage(message)));
      FirebaseMessaging.onMessageOpenedApp.listen((message) =>
          Future.delayed(const Duration(seconds: 1))
              .then((value) => handleMessage(message)));
      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        if (notification == null) return;
        if (Platform.isAndroid) {
          _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                _androidChannel.description,
                icon: 'mipmap/ic_logo',
                playSound: true,
                importance: Importance.max,
                priority: Priority.high,
                vibrationPattern: Int64List.fromList([0, 1000]),
                sound: const RawResourceAndroidNotificationSound('ovumb'),
              ),
              iOS: const IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                sound: 'ovumb.wav',
              ),
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //request permission for notification
  Future<void> requestNotificationPermission() async {
    final bool isNotificationPermissionGranted =
        await Permission.notification.isGranted;

    if (!isNotificationPermissionGranted) {
      await Permission.notification.request();
    }

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  //handle message
  handleMessage(RemoteMessage? message) {
    if (message != null) {
      int? id = int.tryParse(message.data["id"] ?? 0);
      NotificationType type =
          NotificationType.toEnum(int.parse(message.data["type"]));
      NotificationNavigator().handleNextPressed(null, type, id);
    }
    debugPrint('handleMessage');
    debugPrint(message.toString());
  }

  //handle background message
  Future<void> handleBackgroundMessage(RemoteMessage? message) async {
    if (message != null) {
      //AppNavigator.router.pushNamed(AppRoute.noti.path);
    }
    debugPrint('handleBackgroundMessage');
    debugPrint(message.toString());
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        //initLocalNotifications();
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      _androidChannel.id.toString(),
      _androidChannel.name.toString(),
      _androidChannel.description.toString(),
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('ovumb'),
    );

    const IOSNotificationDetails darwinNotificationDetails =
        IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'ovumb.wav',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title.toString(),
      message.notification?.body.toString(),
      notificationDetails,
    );
  }
}

class NotificationNavigator {
  final _order = OrderV2Repository();
  final _noti = NotificationRepository();

  handleNextPressed(BuildContext? context, NotificationType type, var id,
      {int? notiId}) async {
    try {
      if (context != null) {
        LoadingCircle().show(context: context);
      }
      switch (type) {
        case NotificationType.user:
          final res = await _noti.getNotificationDetail(notiId ?? id);
          if (res.isOk) {
            navigatorKey.currentState?.pushNamed(
              ReminderDetail.routeName,
              arguments: res.data,
            );
          }
          break;
        case NotificationType.order:
          final res = await _order.getOrder(id);
          if (res.isOk) {
            navigatorKey.currentState?.pushNamed(
              StoreOrderDetailScreen.routeName,
              arguments: {
                "index": 0,
                "order": res.data,
                "orders": List<Order>.empty(),
              },
            );
          }
          break;
        case NotificationType.discount:
          final res = await _order.getDiscountProducts();
          if (res.isOk) {
            navigatorKey.currentState?.pushNamed(
              StoreDiscountProductScreen.routeName,
              arguments: res.data,
            );
          }
          break;
        default:
      }
      if (context != null) {
        LoadingCircle().hide();
      }
    } on DioException catch (e) {
      if (context != null) {
        LoadingCircle().hide();
        context.showErrorToast(e.messageTr);
      }
    }
  }
}
