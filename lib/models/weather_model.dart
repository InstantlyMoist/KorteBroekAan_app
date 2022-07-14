import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/models/weather_forecast_daily_model.dart';
import 'package:kortebroekaan/models/weather_forecast_hourly_model.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class WeatherModel {
  late String cityName;
  late String countryName;

  late int conditionCode;

  late double uv;
  late double feelsLike;

  // 3 Day forecast
  late List<WeatherForecastDailyModel> dailyForecast;

  // Hourly forecast
  late List<WeatherForecastHourlyModel> hourlyForecast;

  WeatherModel(Map<String, dynamic> weatherData) {
    // Location data:
    cityName = weatherData['location']['name'];
    countryName = weatherData['location']['country'];

    conditionCode = weatherData['current']['condition']['code'];

    uv = weatherData['current']['uv'].toDouble();
    feelsLike = weatherData['current']['feelslike_c'].toDouble();

    dailyForecast = [];
    hourlyForecast = [];

    // 3 day forecast data
    // This is also to be combined with the hourly forecast data, we can simply throw all of it in, and filter it later.
    String currentHour = DateTime.now().hour.toString();
    bool first = false;
    weatherData['forecast']['forecastday'].forEach(
      (day) {
        day['hour'].forEach(
          (hour) {
            String forecastHour =
                DateTime.fromMillisecondsSinceEpoch(hour['time_epoch'] * 1000)
                    .hour
                    .toString();
            if (!first) {
              if (forecastHour != currentHour) {
                return;
              }
              first = true;
              try {
                forecastHour = translate("_screens._home_screen.now");
              } catch (e) {
                forecastHour = "Nu";
              }
            }
            hourlyForecast.add(
              WeatherForecastHourlyModel(
                hour['temp_c'].toDouble(),
                hour['chance_of_rain'].toDouble(),
                forecastHour,
                hour['condition']['code'],
              ),
            );
          },
        );
        dailyForecast.add(
          WeatherForecastDailyModel(
            day['day']['maxtemp_c'].toDouble(),
            day['day']['daily_chance_of_rain'].toDouble(),
          ),
        );
      },
    );

    hourlyForecast =
        hourlyForecast.sublist(0, 24 + (24 - int.parse(currentHour)));
  }

  String temperatureParsedString() =>
      "${(SharedPreferencesProvider.celcius ? feelsLike : feelsLike * 1.8 + 32).toStringAsFixed(1)}°${SharedPreferencesProvider.celcius ? 'C' : 'F'}";
}
