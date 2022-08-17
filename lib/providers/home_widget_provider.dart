import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:home_widget/home_widget.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/providers/weather_provider.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
//final now = DateTime.now();
    await SharedPreferencesProvider.load();
    await dotenv.load(fileName: ".env");
    WeatherModel model =
        await WeatherProvider.getWeather(inputData!['location']);
    HomeWidget.saveWidgetData(
        "imageName", model.dailyForecast[0].shortPants() ? "yes" : "no");
    HomeWidget.updateWidget(
        name: "HomeWidgetExampleProvider", iOSName: "KorteBroekAanWidget");
    return Future.wait<bool?>([]).then((value) {
      return !value.contains(false);
    });
  });
}

class HomeWidgetProvider {
  static void init(String location) async {
    await HomeWidget.setAppGroupId('group.kortebroekaan');
    // Get platform
    if (Platform.isIOS) return;
    await Workmanager().initialize(callbackDispatcher,
        isInDebugMode: false);
    Workmanager().cancelAll();
    Workmanager().registerPeriodicTask(
      "kortebroekaan_widget_update",
      'widgetBackgroundUpdate',
      inputData: {
        'location': location,
      },
      frequency: const Duration(hours: 12),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
          networkType: NetworkType.connected, requiresCharging: false),
    );
  }

  static Future<bool> updateWidget(bool shortPants) async {
    await HomeWidget.saveWidgetData("imageName", shortPants ? "yes" : "no");
    await HomeWidget.updateWidget(
        name: "HomeWidgetExampleProvider", iOSName: "KorteBroekAanWidget");
    return true;
  }
}
