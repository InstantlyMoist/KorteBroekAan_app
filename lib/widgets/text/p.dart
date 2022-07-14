import 'package:flutter/material.dart';

class P extends StatelessWidget {
  P({Key? key, required this.text, required this.color, this.align = TextAlign.left}) : super(key: key);

  String text;
  Color color;
  TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(color: color, fontSize: 16),
    );
  }
}
