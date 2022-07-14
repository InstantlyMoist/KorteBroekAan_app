import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenPusher {
  static Future<void> pushScreen(BuildContext context, Widget route, bool shouldPop) async {
    if (shouldPop) Navigator.of(context).pop();
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => route),
    );
  }
}