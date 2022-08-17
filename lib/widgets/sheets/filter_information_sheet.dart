import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/utils/string_utils.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';
import 'package:kortebroekaan/utils/short_pants_calculator.dart';

class FilterInformationSheet extends StatefulWidget {
  FilterInformationSheet({Key? key, required this.shortPants})
      : super(key: key);

  bool shortPants;

  @override
  State<FilterInformationSheet> createState() => _FilterInformationSheetState();
}

class _FilterInformationSheetState extends State<FilterInformationSheet> {
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
              color: AppColors.shortPantsLightColor(widget.shortPants),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  H1(
                    text: translate("_sheets._filter_information_sheet.title"),
                    color: AppColors.shortPantsDarkColor(widget.shortPants),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  P(
                    text: translate("_sheets._filter_information_sheet.text"),
                    color: AppColors.shortPantsDarkColor(widget.shortPants),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  P(
                    text: translate(
                      "_sheets._filter_information_sheet.current",
                      args: {"temperature": StringUtils.temperatureParsedString(ShortPantsCalculator.minTemperature()), "chance": ShortPantsCalculator.maxRainChance()},
                    ),
                    color: AppColors.shortPantsDarkColor(widget.shortPants),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    text: translate("_sheets._filter_information_sheet.close"),
                    buttonColor:
                        AppColors.shortPantsDarkColor(widget.shortPants),
                    textColor:
                        AppColors.shortPantsLightColor(widget.shortPants),
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
