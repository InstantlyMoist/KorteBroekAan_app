import 'dart:convert';

import 'package:kortebroekaan/constants/weather_url.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherProvider {

  static Future<WeatherModel> getWeather(String location) async {
    String weatherUrl = WeatherUrl.getUrl(location);
    Uri uri = Uri.parse(weatherUrl);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return WeatherModel(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}