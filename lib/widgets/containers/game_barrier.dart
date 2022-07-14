import 'package:flutter/material.dart';
import 'package:kortebroekaan/constants/app_colors.dart';

class GameBarrier extends StatelessWidget {
  GameBarrier(
      {Key? key,
      required this.shortPants,
      required this.x,
      required this.width,
      required this.height,
      required this.bottom})
      : super(key: key);

  bool shortPants;
  double x;
  double width;
  double height;
  bool bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (2 * x + width / (2 - width)),
        bottom ? 1 : -1,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.shortPantsDarkColor(shortPants),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottom ? 0 : 10),
            bottomRight: Radius.circular(bottom ? 0 : 10),
            topLeft: Radius.circular(bottom ? 10 : 0),
            topRight: Radius.circular(bottom ? 10 : 0),
          ),
        ),
        width: MediaQuery.of(context).size.width * width / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * height / 2,
      ),
    );
  }
}
