import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kortebroekaan/constants/app_colors.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {Key? key,
      this.size = 24,
      this.data,
      this.svgAsset,
      required this.onPressed,
      required this.shortPants})
      : super(key: key);

  double size;
  IconData? data;
  String? svgAsset;
  VoidCallback onPressed;
  bool shortPants;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: AppColors.shortPantsLightColor(shortPants),
          ),
          child: Padding(
            padding: EdgeInsets.all(size / 2),
            child: data != null
                ? Icon(
                    data,
                    size: size,
                    color: AppColors.shortPantsDarkColor(
                      shortPants,
                    ),
                  )
                : SizedBox(
                    height: size,
                    child: SvgPicture.asset(
                      svgAsset!,
                      color: AppColors.shortPantsDarkColor(shortPants),
                      width: size,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
