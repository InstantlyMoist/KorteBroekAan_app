import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/screens/home_screen.dart';
import 'package:kortebroekaan/screens/splash_screen.dart';
import 'package:kortebroekaan/utils/screen_pusher.dart';
import 'package:kortebroekaan/utils/short_pants_calculator.dart';
import 'package:kortebroekaan/widgets/buttons/settings_button.dart';
import 'package:kortebroekaan/widgets/buttons/svg_button.dart';
import 'package:kortebroekaan/widgets/sheets/filter_information_sheet.dart';
import 'package:kortebroekaan/widgets/sliders/settings_slider.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/toggles/settings_toggle.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key, required this.weatherModel, required this.onUpdate})
      : super(key: key);

  WeatherModel weatherModel;
  VoidCallback onUpdate;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _update() {
    widget.onUpdate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shortPantsDarkColor(
          widget.weatherModel.dailyForecast[0].shortPants()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.shortPantsLightColor(
                        widget.weatherModel.dailyForecast[0].shortPants(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  H1(
                    text: translate("_screens._settings_screen.title"),
                    color: AppColors.shortPantsLightColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              SettingsSlider(
                shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
                onUpdate: _update,
                bottomSheet: FilterInformationSheet(
                  shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SettingsToggle(
                shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
                firstOption: translate("_screens._settings_screen._theme.dark"),
                secondOption:
                    translate("_screens._settings_screen._theme.light"),
                title: translate("_screens._settings_screen._theme.title"),
                preferencesName: "darkMode",
                onUpdate: _update,
              ),
              const SizedBox(
                height: 32,
              ),
              SettingsToggle(
                shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
                firstOption: "°C",
                secondOption: "ºF",
                title: translate("_screens._settings_screen._unit.title"),
                preferencesName: "celcius",
                onUpdate: _update,
              ),
              const SizedBox(
                height: 32,
              ),
              SettingsToggle(
                shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
                firstOption:
                    translate("_screens._settings_screen._notifications.on"),
                secondOption:
                    translate("_screens._settings_screen._notifications.off"),
                title:
                    translate("_screens._settings_screen._notifications.title"),
                preferencesName: "notifications",
                onUpdate: _update,
              ),
              SettingsButton(
                title: "Locatie instellingen",
                buttonText:
                    translate("_screens._settings_screen.reset_location"),
                onTap: () {
                  SharedPreferencesProvider.removeLocationSettings();
                  ScreenPusher.pushScreen(context, const SplashScreen(), true);
                },
                buttonColor: AppColors.shortPantsLightColor(
                  widget.weatherModel.dailyForecast[0].shortPants(),
                ),
                textColor: AppColors.shortPantsDarkColor(
                  widget.weatherModel.dailyForecast[0].shortPants(),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  SvgButton(
                    url: "https://github.com/InstantlyMoist/KorteBroekAan_app/",
                    assetName: "assets/icons/github.svg",
                    lightColor: AppColors.shortPantsLightColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                    darkColor: AppColors.shortPantsDarkColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SvgButton(
                    assetName: "assets/icons/instagram.svg",
                    url: "https://instagram.com/kortebroekaan_nl/",
                    lightColor: AppColors.shortPantsLightColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                    darkColor: AppColors.shortPantsDarkColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SvgButton(
                    assetName: "assets/icons/website.svg",
                    url: "https://kortebroekaan.nl",
                    lightColor: AppColors.shortPantsLightColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                    darkColor: AppColors.shortPantsDarkColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SvgButton(
                    assetName: "assets/icons/patreon.svg",
                    url: "https://www.patreon.com/kortebroekaan_nl",
                    lightColor: AppColors.shortPantsLightColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                    darkColor: AppColors.shortPantsDarkColor(
                      widget.weatherModel.dailyForecast[0].shortPants(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
