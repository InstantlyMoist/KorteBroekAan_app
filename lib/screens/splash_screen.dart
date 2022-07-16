import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kortebroekaan/constants/location_type.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/database_provider.dart';
import 'package:kortebroekaan/providers/home_widget_provider.dart';
import 'package:kortebroekaan/providers/notification_provider.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/providers/weather_provider.dart';
import 'package:kortebroekaan/screens/home_screen.dart';
import 'package:kortebroekaan/utils/image_grayscaler.dart';
import 'package:kortebroekaan/utils/modal_shower.dart';
import 'package:kortebroekaan/utils/screen_pusher.dart';
import 'package:kortebroekaan/widgets/sheets/ask_location_sheet.dart';
import 'package:kortebroekaan/widgets/sheets/location_type_sheet.dart';
import 'package:kortebroekaan/widgets/text/p.dart';
import 'package:kortebroekaan/widgets/text/pTiny.dart';
import 'package:location/location.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late var facts;
  String _fact = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    changeLocale(context, SharedPreferencesProvider.language);

    var jsonText =
        await rootBundle.loadString('assets/splash_screen_hints.json');
    facts = jsonDecode(jsonText);
    setRandomFact();

    await dotenv.load(fileName: ".env");

    String location =
        await getLocation(); // This returns the location as a string which can be used to get the weather

    HomeWidgetProvider.init(location);

    WeatherModel weather = await WeatherProvider.getWeather(location);

    await DatabaseProvider.init();

    await AppTrackingTransparency.requestTrackingAuthorization();

    await NotificationProvider.init();
    SharedPreferencesProvider.notifications
        ? NotificationProvider.register()
        : NotificationProvider.unregister();

    ScreenPusher.pushScreen(
      context,
      HomeScreen(weatherModel: weather),
      true,
    );
  }

  Future<String> getLocation() async {
    LocationType? locationType = SharedPreferencesProvider.locationType;
    if (locationType == null) {
      String? response = await ModalShower.showModalSheetWithStringCallback(
          context, const LocationTypeSheet());
      LocationType type = LocationType.values.firstWhere(
          (e) => e.toString() == response,
          orElse: () => LocationType.manual);
      SharedPreferencesProvider.setLocationType(type);
      return await getLocation();
    } else {
      if (locationType == LocationType.manual) {
        if (SharedPreferencesProvider.location != null) {
          return SharedPreferencesProvider.location!;
        }
        String? location = await ModalShower.showModalSheetWithStringCallback(
            context, const AskLocationSheet());
        if (location == null || location.trim().isEmpty) {
          return await getLocation();
        }
        if (location == "LocationType.automatic") {
          // User changed his mind, so we reset the location type
          SharedPreferencesProvider.setLocationType(LocationType.automatic);
          return await getLocation();
        }
        SharedPreferencesProvider.location = location;
        SharedPreferencesProvider.save();
        return location;
      } else {
        Location location = Location();

        bool serviceEnabled;
        PermissionStatus permissionGranted;

        serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
          if (!serviceEnabled) {
            SharedPreferencesProvider.setLocationType(LocationType.manual);
            return await getLocation();
          }
        }

        permissionGranted = await location.hasPermission();
        if (permissionGranted == PermissionStatus.denied) {
          permissionGranted = await location.requestPermission();
          if (permissionGranted != PermissionStatus.granted) {
            SharedPreferencesProvider.locationType = LocationType.manual;
            SharedPreferencesProvider.save();
            return await getLocation();
          }
        }

        LocationData locationData = await location.getLocation();
        return "${locationData.latitude},${locationData.longitude}";
      }
    }
  }

  void setRandomFact() {
    setState(() {
      _fact = facts["facts"][Random().nextInt(facts["facts"].length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shortPantsLightColor(true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ImageGrayscaler.getGrayScaled(
              SharedPreferencesProvider.darkMode,
              const Image(
                image: AssetImage('assets/images/yes-man-plain.png'),
                height: 300,
              ),
            ),
            SpinKitThreeBounce(
              color: AppColors.shortPantsDarkColor(true),
              size: 24.0,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => setRandomFact(),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.lighter(true),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: P(
                    align: TextAlign.justify,
                    text: _fact,
                    color: AppColors.shortPantsDarkColorException(true),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
