import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareProvider {
  static void share(WeatherModel model, BuildContext context) async {
    String shareMessage = translate(
        "_screens._share.${model.dailyForecast[0].shortPants() ? "yes" : "no"}",
        args: {
          "location": model.cityName,
          "temp": model.dailyForecast[0].temperature,
          "chance": model.dailyForecast[0].rainChance,
        });
    File image = await getImageFileFromAssets(
        model.dailyForecast[0].shortPants()
            ? "assets/images/yes-share.png"
            : "assets/images/no-share.png");
    String path = image.path;

    Share.shareFiles([path], text: shareMessage);

    FirebaseAnalytics.instance.logEvent(
      name: "shared",
    );
  }

  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
