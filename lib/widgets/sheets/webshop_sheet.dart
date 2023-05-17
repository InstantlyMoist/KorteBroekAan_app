import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/utils/url_launcher.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class WebshopSheet extends StatelessWidget {
  WebshopSheet({
    Key? key,
    required this.darkColor,
    required this.lightColor,
  }) : super(key: key);

  String url = "https://kortebroekaan.nl/winkel/";
  Color darkColor;
  Color lightColor;

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
              color: lightColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  H1(
                    text: translate("_sheets._webshop_sheet.title"),
                    color: darkColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  P(
                    text: translate("_sheets._webshop_sheet.text"),
                    color: darkColor,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: translate("_sheets._webshop_sheet.open"),
                    buttonColor: darkColor,
                    textColor: lightColor,
                    onPressed: () => {
                      Navigator.of(context).pop(),
                      UrlLauncher.launch(url),
                      SharedPreferencesProvider.toggleByName(
                          "webshopMessageSeen")
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: translate("_sheets._webshop_sheet.close"),
                    buttonColor: lightColor,
                    textColor: darkColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                      SharedPreferencesProvider.toggleByName(
                          "webshopMessageSeen");
                    },
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
