import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class LocationTypeSheet extends StatefulWidget {
  const LocationTypeSheet({Key? key}) : super(key: key);

  @override
  State<LocationTypeSheet> createState() => _LocationTypeSheetState();
}

class _LocationTypeSheetState extends State<LocationTypeSheet> {
  void _pop(String callback) {
    Navigator.pop(context, callback);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.green(false),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    H1(
                      text: translate("_sheets._location_type_sheet.title"),
                      color: AppColors.green(true),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    P(
                      text: translate("_sheets._location_type_sheet.text"),
                      color: AppColors.green(true),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Center(
                      child: Image(
                        height: 200,
                        image: AssetImage("assets/images/unknown-man.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      text: translate("_sheets._location_type_sheet.manual"),
                      buttonColor: AppColors.green(true),
                      textColor: AppColors.green(false),
                      onPressed: () => _pop("LocationType.manual"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      text: translate("_sheets._location_type_sheet.automatic"),
                      buttonColor: AppColors.green(true),
                      textColor: AppColors.green(false),
                      onPressed: () => _pop("LocationType.automatic"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
