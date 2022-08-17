import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class StringUtils {
  static String addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  static String temperatureParsedString(double temp) =>
      "${(SharedPreferencesProvider.celcius ? temp : temp * 1.8 + 32).toStringAsFixed(1)}°${SharedPreferencesProvider.celcius ? 'C' : 'F'}";

}
