import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kortebroekaan/constants/location_type.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static late SharedPreferences _preferences;

  static WeatherModel? model;

  static late List<String> languages;
  static String language = "nl";

  static LocationType? locationType;
  static String? location;
  static int filterStrength = 2;
  static int topScore = 0;

  static bool darkMode = false;
  static bool celcius = true;
  static bool notifications = true;
  static bool webshopMessageSeen = false;

  static bool removeAdsPurchased = false;

  static bool adShown = false;

  static DateTime? canVoteIn;
  static TimeOfDay notificationTime = const TimeOfDay(hour: 07, minute: 00);

  static Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();

    if (_preferences.containsKey('locationType')) {
      locationType = LocationType.values[_preferences.getInt('locationType')!];
    }
    if (_preferences.containsKey('location')) {
      location = _preferences.getString('location');
    }
    if (_preferences.containsKey('filterStrength')) {
      filterStrength = _preferences.getInt('filterStrength')!;
    }
    if (_preferences.containsKey('darkMode')) {
      darkMode = _preferences.getBool('darkMode')!;
    }
    if (_preferences.containsKey('webshopMessageSeen')) {
      webshopMessageSeen = _preferences.getBool('webshopMessageSeen')!;
    }
    if (_preferences.containsKey('celcius')) {
      celcius = _preferences.getBool('celcius')!;
    }
    if (_preferences.containsKey('notifications')) {
      notifications = _preferences.getBool('notifications')!;
    }
    if (_preferences.containsKey("canVoteIn")) {
      canVoteIn = DateTime.fromMillisecondsSinceEpoch(
          _preferences.getInt("canVoteIn")!);
    } else {
      canVoteIn = DateTime.now();
    }
    if (_preferences.containsKey("topScore")) {
      topScore = _preferences.getInt("topScore")!;
    }
    if (_preferences.containsKey("removeAdsPurchased")) {
      removeAdsPurchased = _preferences.getBool("removeAdsPurchased")!;
    }
    if (_preferences.containsKey("notificationTime")) {
      String timeBuffer = _preferences.getString("notificationTime")!;
      List<String> timeBufferList = timeBuffer.split(":");
      notificationTime = TimeOfDay(
        hour: int.parse(timeBufferList[0]),
        minute: int.parse(timeBufferList[1]),
      );
    }
    if (_preferences.containsKey("language")) {
      language = _preferences.getString("language")!;
    }
    if (_preferences.containsKey("model")) {
      String modelBuffer = _preferences.getString("model")!;
      WeatherModel buffer = WeatherModel.fromJson(jsonDecode(modelBuffer));
      if (buffer.createdAt + 1800000 > DateTime.now().millisecondsSinceEpoch) {
        model = buffer; // Else the model is expired and we don't want it to update
      }
    }
  }

  static void removeLocationSettings() {
    locationType = null;
    location = null;

    model = null;

    _preferences.remove('locationType');
    _preferences.remove('location');

    _preferences.remove("model"); // Remove the model aswell, as it is no longer valid

    save();
  }

  static void save() {
    if (locationType != null) {
      _preferences.setInt('locationType', locationType!.index);
    }
    if (location != null) {
      _preferences.setString('location', location!);
    }
    _preferences.setInt('filterStrength', filterStrength);
    _preferences.setBool('darkMode', darkMode);
    _preferences.setBool('celcius', celcius);
    _preferences.setBool('notifications', notifications);
    _preferences.setBool('webshopMessageSeen', webshopMessageSeen);
    _preferences.setInt("canVoteIn", canVoteIn!.millisecondsSinceEpoch);
    _preferences.setInt("topScore", topScore);
    _preferences.setBool("removeAdsPurchased", removeAdsPurchased);
    _preferences.setString("notificationTime",
        "${notificationTime.hour}:${notificationTime.minute}");
    _preferences.setString("language", language);

    if (model != null) {
      _preferences.setString("model", jsonEncode(model!.toJson()));
    }
  }

  static void setLocationType(LocationType type) {
    locationType = type;
    save();
  }

  static void toggleByName(String name) {
    if (name == 'darkMode') {
      darkMode = !darkMode;
    }
    if (name == 'celcius') {
      celcius = !celcius;
    }
    if (name == 'webshopMessageSeen') {
      webshopMessageSeen = true;
    }
    if (name == 'notifications') {
      notifications = !notifications;
      notifications
          ? NotificationProvider.register()
          : NotificationProvider.unregister();
    }
    save();
  }

  static bool getByName(String name) {
    if (name == 'darkMode') {
      return darkMode;
    }
    if (name == 'celcius') {
      return celcius;
    }
    if (name == 'notifications') {
      return notifications;
    }
    return false;
  }
}
