import 'package:flutter/material.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';

class SettingsToggle extends StatefulWidget {
  SettingsToggle(
      {Key? key,
      required this.shortPants,
      required this.firstOption,
      required this.secondOption,
      required this.title,
      required this.preferencesName,
      required this.onUpdate})
      : super(key: key);

  bool shortPants;
  String firstOption;
  String secondOption;
  String title;
  String preferencesName;
  VoidCallback onUpdate;

  @override
  State<SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<SettingsToggle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            color: AppColors.shortPantsLightColor(
              widget.shortPants,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
              SharedPreferencesProvider.toggleByName(widget.preferencesName);
              widget.onUpdate();
            // setState(() {

            // });
          },
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.shortPantsLightColor(
                widget.shortPants,
              ),
              borderRadius: BorderRadius.circular(
                5,
              ),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: 100,
                  ),
                  left: SharedPreferencesProvider.getByName(
                          widget.preferencesName)
                      ? 2
                      : 50,
                  bottom: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shortPantsDarkColor(
                        widget.shortPants,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 48,
                    height: 36,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.firstOption,
                          style: TextStyle(
                            color: AppColors.shortPantsLightColor(
                              widget.shortPants,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.secondOption,
                          style: TextStyle(
                            color: AppColors.shortPantsLightColor(
                              widget.shortPants,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
