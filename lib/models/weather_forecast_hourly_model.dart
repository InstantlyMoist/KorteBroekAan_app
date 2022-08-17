import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class WeatherForecastHourlyModel {
  double temperature;
  double rainChance;
  String hour;
  int conditionCode;

  WeatherForecastHourlyModel(
    this.temperature,
    this.rainChance,
    this.hour,
    this.conditionCode,
  );

  String temperatureParsedString() =>
      "${(SharedPreferencesProvider.celcius ? temperature : temperature * 1.8 + 32).toStringAsFixed(1)}°${SharedPreferencesProvider.celcius ? 'C' : 'F'}";

  WeatherForecastHourlyModel.fromJson(Map<String, dynamic> json)
      : temperature = json['temp_c'].toDouble(),
        rainChance = json['chance_of_rain'].toDouble(),
        hour = json['hour'],
        conditionCode = json['conditionCode'];

  Map<String, dynamic> toJson() => {
        'temp_c': temperature,
        'chance_of_rain': rainChance,
        'hour': hour,
        'conditionCode': conditionCode,
      };
}
