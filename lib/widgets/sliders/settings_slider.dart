import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/utils/modal_shower.dart';
import 'package:kortebroekaan/widgets/text/p.dart';

class SettingsSlider extends StatefulWidget {
  SettingsSlider(
      {Key? key,
      this.bottomSheet,
      required this.shortPants,
      required this.onUpdate})
      : super(key: key);

  Widget? bottomSheet;

  bool shortPants;
  VoidCallback onUpdate;

  @override
  State<SettingsSlider> createState() => _SettingsSliderState();
}

class _SettingsSliderState extends State<SettingsSlider> {
  double _sliderValue = SharedPreferencesProvider.filterStrength.toDouble();

  String _getFilterName() {
    return translate("_screens._settings_screen._filter._values.${_sliderValue.toInt() - 1}");
    // switch (_sliderValue.toInt()) {
    //   case 1:
    //     return "Watje";
    //   case 2:
    //     return "Gemiddeld";
    //   case 3:
    //     return "Gedurfd";
    //   default:
    //     return "Legende";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            P(
              text: translate("_screens._settings_screen._filter.title"),
              color: AppColors.shortPantsLightColor(widget.shortPants),
            ),
            Row(
              children: [
                P(
                  text: _getFilterName(),
                  color: AppColors.shortPantsLightColor(widget.shortPants),
                ),
                const SizedBox(
                  width: 8,
                ),
                if (widget.bottomSheet != null)
                  GestureDetector(
                    child: GestureDetector(
                      onTap: () => ModalShower.showModalSheet(
                          context, widget.bottomSheet!),
                      child: Icon(
                        Icons.info_outline,
                        color:
                            AppColors.shortPantsLightColor(widget.shortPants),
                      ),
                    ),
                  )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackShape: CustomTrackShape(),
              overlayColor: AppColors.shortPantsLightColor(
                widget.shortPants,
              ).withOpacity(0.1),
              activeTrackColor: AppColors.shortPantsLightColor(
                widget.shortPants,
              ),
              inactiveTrackColor: AppColors.shortPantsLightColor(
                widget.shortPants,
              ),
              activeTickMarkColor: AppColors.shortPantsLightColor(
                widget.shortPants,
              ),
              inactiveTickMarkColor: AppColors.shortPantsLightColor(
                widget.shortPants,
              ),
              thumbColor: AppColors.shortPantsLightColor(
                widget.shortPants,
              ),

            ),
            child: Slider(
              value: _sliderValue,
              min: 1,
              max: 4,
              divisions: 3,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                  SharedPreferencesProvider.filterStrength = value.toInt();
                  SharedPreferencesProvider.save();
                  widget.onUpdate();
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
