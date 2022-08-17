import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class ShortPantsCalculator {
  static bool shortPants(double currentTemperature, double currentRainChance) {
    int filterStrength = SharedPreferencesProvider.filterStrength;
    int rainChance = maxRainChance();
    double temperature = minTemperature();
    switch (filterStrength) {
      case 1:
        return false;
      case 2:
        return currentRainChance < rainChance && currentTemperature > temperature;
      case 3:
        return currentRainChance < rainChance && currentTemperature > temperature;
      default:
        return true;
    }
  }

  static int maxRainChance() {
    int filterStrength = SharedPreferencesProvider.filterStrength;
    switch (filterStrength) {
      case 1:
        return 0;
      case 2:
        return 90;
      case 3:
        return 95;
      default:
        return 100;
    }
  }

  static double minTemperature() {
    int filterStrength = SharedPreferencesProvider.filterStrength;
    switch (filterStrength) {
      case 1:
        return 0;
      case 2:
        return 15;
      case 3:
        return 10;
      default:
        return 0;
    }
  }
}
