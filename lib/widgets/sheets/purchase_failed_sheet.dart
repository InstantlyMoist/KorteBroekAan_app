import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/utils/image_grayscaler.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class PurchaseFailedSheet extends StatelessWidget {
  PurchaseFailedSheet({Key? key, required this.shortPants}) : super(key: key);

  bool shortPants;

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
              color: AppColors.shortPantsLightColor(shortPants),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  H1(
                    text: translate("_sheets._purchase_failed_sheet.title"),
                    color: AppColors.shortPantsDarkColor(shortPants),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: ImageGrayscaler.getGrayScaled(
                      SharedPreferencesProvider.darkMode,
                      const Image(
                        height: 200,
                        image: AssetImage("assets/images/no-man-plain.png"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  P(
                    text: translate("_sheets._purchase_failed_sheet.text"),
                    color: AppColors.shortPantsDarkColor(shortPants),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: translate("_sheets._filter_information_sheet.close"),
                    buttonColor: AppColors.shortPantsDarkColor(shortPants),
                    textColor: AppColors.shortPantsLightColor(shortPants),
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
