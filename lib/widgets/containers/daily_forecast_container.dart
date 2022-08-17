import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/widgets/entries/daily_forecast_entry.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class DailyForecastContainer extends StatefulWidget {
  DailyForecastContainer(
      {Key? key, required this.shortPants, required this.model})
      : super(key: key);

  bool shortPants;
  WeatherModel model;

  @override
  State<DailyForecastContainer> createState() => _DailyForecastContainerState();
}

class _DailyForecastContainerState extends State<DailyForecastContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lighter(widget.shortPants),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              P(
                text: translate("_screens._home_screen.daily_forecast"),
                color: AppColors.shortPantsDarkColorException(widget.shortPants),
              ),
              for (int i = 0; i < widget.model.dailyForecast.length; i++)
                DailyForecastEntry(
                  index: i,
                  model: widget.model.dailyForecast[i],
                  shortPants: widget.shortPants,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
