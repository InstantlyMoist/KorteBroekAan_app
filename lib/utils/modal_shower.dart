import 'package:flutter/material.dart';

class ModalShower {
  static Future<void> showModalSheet(BuildContext context, Widget sheet) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => sheet);
    return;
  }

  static Future<String?> showModalSheetWithStringCallback(
      BuildContext context, Widget sheet) async {
    return await showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => sheet);
  }
}