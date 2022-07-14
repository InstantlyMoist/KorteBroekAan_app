import 'package:kortebroekaan/constants/location_type.dart';
import 'package:kortebroekaan/providers/notification_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static late SharedPreferences _preferences;

  static LocationType? locationType;
  static String? location;
  static int filterStrength = 2;
  static int topScore = 0;

  static bool darkMode = false;
  static bool celcius = true;
  static bool notifications = true;

  static bool adShown = false;

  static DateTime? canVoteIn;

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
  }

  static void removeLocationSettings() {
    locationType = null;
    location = null;

    _preferences.remove('locationType');
    _preferences.remove('location');

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
    _preferences.setInt("canVoteIn", canVoteIn!.millisecondsSinceEpoch);
    _preferences.setInt("topScore", topScore);
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
