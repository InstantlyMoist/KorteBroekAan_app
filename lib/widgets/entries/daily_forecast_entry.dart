import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/weather_forecast_daily_model.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class DailyForecastEntry extends StatelessWidget {
  DailyForecastEntry(
      {Key? key,
      required this.model,
      required this.shortPants,
      required this.index})
      : super(key: key);

  WeatherForecastDailyModel model;
  bool shortPants;
  int index;

  String getDay() {
    if (index == 0) {
      return translate("_days.today");
    } else if (index == 1) {
      return translate("_days.tomorrow");
    } else {
      return translate("_days.day_after_tomorrow");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Divider(
          color: AppColors.shortPantsDarkColorException(shortPants)
              .withOpacity(0.1),
          thickness: 1,
        ),
        Row(
          children: [
            P(
              text: getDay(),
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
            const SizedBox(width: 8),
            Icon(
              model.shortPants() ? Icons.check : Icons.close,
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
            const Spacer(),
            Icon(
              Icons.water_drop_outlined,
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
            P(
              text: "${model.rainChance}%",
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.thermostat_rounded,
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
            P(
              text: model.temperatureParsedString(),
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
          ],
        )
      ],
    );
  }
}
