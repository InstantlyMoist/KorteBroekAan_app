import 'package:flutter/material.dart';

class PTiny extends StatelessWidget {
  PTiny({Key? key, required this.text, required this.color}) : super(key: key);

  String text;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: TextStyle(color: color, fontSize: 12),
    );
  }
}
