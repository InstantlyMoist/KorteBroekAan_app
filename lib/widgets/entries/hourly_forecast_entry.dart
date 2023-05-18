import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kortebroekaan/constants/app_colors.dart';

class HourlyForecastEntry extends StatelessWidget {
  const HourlyForecastEntry(
      {Key? key,
      required this.hour,
      required this.temperature,
      required this.shortPants,
      required this.conditionCode})
      : super(key: key);

  final String hour;
  final int conditionCode;
  final String temperature;
  final bool shortPants;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          Text(
            double.tryParse(hour) != null ? "$hour:00" : hour,
            style: TextStyle(
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SvgPicture.asset(
            "assets/icons/weather/$conditionCode.svg",
            color: AppColors.shortPantsDarkColorException(shortPants),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            temperature,
            style: TextStyle(
              color: AppColors.shortPantsDarkColorException(shortPants),
            ),
          ),
        ],
      ),
    );
  }
}
