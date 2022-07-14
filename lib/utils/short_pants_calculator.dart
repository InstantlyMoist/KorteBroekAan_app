import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class ShortPantsCalculator {
  static bool shortPants(double temperature, double rainChance) {
    int filterStrength = SharedPreferencesProvider.filterStrength;
    switch (filterStrength) {
      case 1:
        return false;
      case 2:
        return rainChance < 90 && temperature > 15;
      case 3:
        return rainChance < 95 && temperature > 10;
      default:
        return true;
    }
  }
}
