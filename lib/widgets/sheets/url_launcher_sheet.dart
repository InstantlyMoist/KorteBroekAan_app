import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/utils/url_launcher.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class UrlLauncherSheet extends StatefulWidget {
  UrlLauncherSheet(
      {Key? key,
      required this.darkColor,
      required this.lightColor,
      required this.url})
      : super(key: key);

  String url;
  Color darkColor;
  Color lightColor;

  @override
  State<UrlLauncherSheet> createState() => _UrlLauncherSheetState();
}

class _UrlLauncherSheetState extends State<UrlLauncherSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.lightColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  H1(
                    text: translate("_sheets._url_launcher_sheet.title"),
                    color: widget.darkColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  P(
                    text:
                       translate("_sheets._url_launcher_sheet.text"),
                    color: widget.darkColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: translate("_sheets._url_launcher_sheet.open"),
                    buttonColor: widget.darkColor,
                    textColor: widget.lightColor,
                    onPressed: () => {
                      Navigator.of(context).pop(),
                      UrlLauncher.launch(widget.url),
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: translate("_sheets._url_launcher_sheet.close"),
                    buttonColor: widget.lightColor,
                    textColor: widget.darkColor,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
