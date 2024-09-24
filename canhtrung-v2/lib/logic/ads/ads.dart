import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/quang_cao.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/server/server_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/ads_dialog.dart';

void showAds({
  required BuildContext context,
  required bool isToday,
  required int type,
}) async {
  final _prefs = SharedPreferencesService();
  String? maNguoiDung = await _prefs.id ?? '';
  final user = await LocalRepository().getNguoiDung(maNguoiDung);
  int phase = user.phase!;
  if (phase == 1) {
    final checkShowCase = await _prefs.showCase;
    if (checkShowCase != null) {
      int? ads1 = await _prefs.ads1;
      if (isToday) {
        if (ads1 == null) {
          await _prefs.setAds1(DateTime.now().add(Duration(days: 1)));
          QuangCao? quangCao =
              await ServerRepository().getAds(phase: phase, type: type);
          if (quangCao != null) {
            CachedNetworkImageProvider(quangCao.image)
                .resolve(ImageConfiguration())
                .addListener(
              ImageStreamListener((info, synchronousCall) async {
                await adsDialog(context, quangCao.image, quangCao.link);
              }),
            );
          }
        } else {
          await _prefs.setAds1(DateTime.now().add(Duration(days: 1)));
          DateTime convertAds1 = DateTime.fromMillisecondsSinceEpoch(ads1);
          if (convertAds1.isBefore(DateTime.now())) {
            QuangCao? quangCao =
                await ServerRepository().getAds(phase: phase, type: type);
            if (quangCao != null) {
              CachedNetworkImageProvider(quangCao.image)
                  .resolve(ImageConfiguration())
                  .addListener(
                ImageStreamListener((info, synchronousCall) async {
                  await adsDialog(context, quangCao.image, quangCao.link);
                }),
              );
            }
          }
        }
      }
    }
  } else if (phase == 2) {
    final checkShowCase = await _prefs.showCase;
    if (checkShowCase != null) {
      int? ads1 = await _prefs.ads2;
      if (isToday) {
        if (ads1 == null) {
          await _prefs.setAds2(DateTime.now().add(Duration(days: 1)));
          QuangCao? quangCao =
              await ServerRepository().getAds(phase: phase, type: type);
          if (quangCao != null) {
            CachedNetworkImageProvider(quangCao.image)
                .resolve(ImageConfiguration())
                .addListener(
              ImageStreamListener((info, synchronousCall) async {
                await adsDialog(context, quangCao.image, quangCao.link);
              }),
            );
          }
        } else {
          await _prefs.setAds2(DateTime.now().add(Duration(days: 1)));
          DateTime convertAds1 = DateTime.fromMillisecondsSinceEpoch(ads1);
          if (convertAds1.isBefore(DateTime.now())) {
            QuangCao? quangCao =
                await ServerRepository().getAds(phase: phase, type: type);
            if (quangCao != null) {
              CachedNetworkImageProvider(quangCao.image)
                  .resolve(ImageConfiguration())
                  .addListener(
                ImageStreamListener((info, synchronousCall) async {
                  await adsDialog(context, quangCao.image, quangCao.link);
                }),
              );
            }
          }
        }
      }
    }
  } else if (phase == 3) {
    int? ads1 = await _prefs.ads3;
    if (isToday) {
      if (ads1 == null) {
        await _prefs.setAds3(DateTime.now().add(Duration(days: 1)));
        QuangCao? quangCao =
            await ServerRepository().getAds(phase: phase, type: type);
        if (quangCao != null) {
          CachedNetworkImageProvider(quangCao.image)
              .resolve(ImageConfiguration())
              .addListener(
            ImageStreamListener((info, synchronousCall) async {
              await adsDialog(context, quangCao.image, quangCao.link);
            }),
          );
        }
      } else {
        await _prefs.setAds3(DateTime.now().add(Duration(days: 1)));
        DateTime convertAds1 = DateTime.fromMillisecondsSinceEpoch(ads1);
        if (convertAds1.isBefore(DateTime.now())) {
          QuangCao? quangCao =
              await ServerRepository().getAds(phase: phase, type: type);
          if (quangCao != null) {
            CachedNetworkImageProvider(quangCao.image)
                .resolve(ImageConfiguration())
                .addListener(
              ImageStreamListener((info, synchronousCall) async {
                await adsDialog(context, quangCao.image, quangCao.link);
              }),
            );
          }
        }
      }
    }
  }
}
