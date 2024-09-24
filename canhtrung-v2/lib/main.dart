import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/firebase_options.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/cart/cart_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/notification/notification_cubit.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/payment/payment_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/store/store_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/splash_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/notification/fcm_notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  //await Firebase.initializeApp();
  await SharedPreferencesService.init();
  await BaseService.instance.initalize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FcmNotificationService().initNotifications();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          create: (BuildContext context) => MainBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<NhatKyCubit>(
          create: (BuildContext context) => NhatKyCubit(),
        ),
        BlocProvider<TestBloc>(
          lazy: true,
          create: (BuildContext context) => TestBloc(),
        ),
        BlocProvider<MilkBloc>(
          create: (BuildContext context) => MilkBloc(),
        ),
        BlocProvider<StoreBloc>(
          create: (BuildContext context) => StoreBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(),
        ),
        BlocProvider<PaymentBloc>(
          create: (BuildContext context) => PaymentBloc(),
        ),
        BlocProvider<NotificationCubit>(
          create: (BuildContext context) => NotificationCubit(),
        ),
      ],
      child: MyApp(),
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(), // Wrap your app
      // ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      designSize: const Size(390, 844),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale('vi', 'VN'),
        supportedLocales: const [
          Locale('en', ''),
          Locale('vi', ''),
        ],
        navigatorObservers: [routeObserver],
        title: 'OvumB',
        theme: ThemeData(
          fontFamily: 'Inter',
          primaryColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: AppBarTheme(color: Colors.white),
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: whiteColor,
            onPrimary: whiteColor,
            secondary: whiteColor,
            onSecondary: whiteColor,
            error: whiteColor,
            onError: whiteColor,
            surface: whiteColor,
            onSurface: grey600,
          ),
        ),
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) => generateRoute(settings),
        home: MediaQuery.withNoTextScaling(child: SplashScreen()),
        builder: (context, child) {
          return MediaQuery.withNoTextScaling(
            child: child ?? const SplashScreen(),
          );
        },
      ),
    );
  }
}
