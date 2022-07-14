import 'package:flutter/material.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class SettingsButton extends StatelessWidget {
  SettingsButton(
      {Key? key,
      required this.title,
      required this.buttonText,
      required this.onTap,
      required this.buttonColor,
      required this.textColor})
      : super(key: key);

  String title;
  String buttonText;
  VoidCallback onTap;
  Color buttonColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        P(
          text: title,
          color: textColor,
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: P(
                text: buttonText,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
