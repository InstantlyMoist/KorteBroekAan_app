import 'package:flutter/material.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.text,
      required this.buttonColor,
      required this.textColor,
      required this.onPressed})
      : super(key: key);

  String text;
  Color buttonColor, textColor;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: P(
              text: text,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
