import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/utils/short_pants_calculator.dart';

class WeatherForecastDailyModel {
  double temperature;
  double rainChance;

  WeatherForecastDailyModel(
    this.temperature,
    this.rainChance,
  );

  bool shortPants() => ShortPantsCalculator.shortPants(temperature, rainChance);

  String temperatureParsedString() =>
      "${(SharedPreferencesProvider.celcius ? temperature : temperature * 1.8 + 32).toStringAsFixed(1)}°${SharedPreferencesProvider.celcius ? 'C' : 'F'}";
}
