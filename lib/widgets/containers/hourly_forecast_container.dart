import 'package:flutter/material.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/widgets/entries/hourly_forecast_entry.dart';

class HourlyForecastContainer extends StatefulWidget {
  HourlyForecastContainer({Key? key, required this.model, required this.shortPants}) : super(key: key);

  WeatherModel model;
  bool shortPants;

  @override
  State<HourlyForecastContainer> createState() =>
      _HourlyForecastContainerState();
}

class _HourlyForecastContainerState extends State<HourlyForecastContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lighter(widget.shortPants),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < widget.model.hourlyForecast.length; i++)
              HourlyForecastEntry(
                temperature: widget.model.hourlyForecast[i].temperatureParsedString(),
                hour: widget.model.hourlyForecast[i].hour,
                conditionCode: widget.model.hourlyForecast[i].conditionCode,
                shortPants: widget.shortPants,
              ),
          ],
        ),
      ),
    );
  }
}
