import 'package:flutter/material.dart';
import 'package:kortebroekaan/constants/app_colors.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {Key? key,
      this.size = 24,
      required this.data,
      required this.onPressed,
      required this.shortPants})
      : super(key: key);

  double size;
  IconData data;
  VoidCallback onPressed;
  bool shortPants;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: AppColors.shortPantsLightColor(shortPants),
        ),
        child: Padding(
          padding: EdgeInsets.all(size / 2),
          child: Icon(
            data,
            size: size,
            color: AppColors.shortPantsDarkColor(
              shortPants,
            ),
          ),
        ),
      ),
    );
  }
}
