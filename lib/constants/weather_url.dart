import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherUrl {
  static String getUrl(String location) {
    return "http://api.weatherapi.com/v1/forecast.json?key=${dotenv.env['WEATHER_API_KEY']}&q=$location&days=5&aqi=no&alerts=no";
  }
}
