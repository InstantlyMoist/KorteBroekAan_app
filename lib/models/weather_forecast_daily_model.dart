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

  WeatherForecastDailyModel.fromJson(Map<String, dynamic> json)
      : temperature = json['maxtemp_c'].toDouble(),
        rainChance = json['daily_chance_of_rain'].toDouble();

  Map<String, dynamic> toJson() => {
        'maxtemp_c': temperature,
        'daily_chance_of_rain': rainChance,
      };
}
