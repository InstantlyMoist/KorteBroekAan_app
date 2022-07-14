import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class AskLocationSheet extends StatefulWidget {
  const AskLocationSheet({Key? key}) : super(key: key);

  @override
  State<AskLocationSheet> createState() => _AskLocationSheetState();
}

class _AskLocationSheetState extends State<AskLocationSheet> {
  void _pop(String callback) {
    if (callback == "LocationType.automatic") {
      Navigator.pop(context, "LocationType.automatic");
      return;
    }
    // Attempting pop, form should be validated
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _locationController.text);
    }
  }

  final TextEditingController _locationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Form(
            key: _formKey,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        H1(
                          text: translate("_sheets._ask_location_sheet.title"),
                          color: AppColors.green(true),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        P(
                          text: translate("_sheets._ask_location_sheet.text"),
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
                        TextFormField(
                          controller: _locationController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return translate("_sheets._ask_location_sheet.enter_location");
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          text: translate("_sheets._ask_location_sheet.automatic"),
                          buttonColor: AppColors.green(true),
                          textColor: AppColors.green(false),
                          onPressed: () => _pop("LocationType.automatic"),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          text: translate("_sheets._ask_location_sheet.continue"),
                          buttonColor: AppColors.green(true),
                          textColor: AppColors.green(false),
                          onPressed: () => _pop("continue"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
