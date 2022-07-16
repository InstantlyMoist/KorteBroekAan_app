import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/in_app_purchases_provider.dart';
import 'package:kortebroekaan/providers/notification_provider.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/screens/splash_screen.dart';
import 'package:kortebroekaan/utils/modal_shower.dart';
import 'package:kortebroekaan/utils/screen_pusher.dart';
import 'package:kortebroekaan/utils/string_utils.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/buttons/settings_button.dart';
import 'package:kortebroekaan/widgets/buttons/svg_button.dart';
import 'package:kortebroekaan/widgets/sheets/filter_information_sheet.dart';
import 'package:kortebroekaan/widgets/sheets/purchase_failed_sheet.dart';
import 'package:kortebroekaan/widgets/sheets/purchase_ok_sheet.dart';
import 'package:kortebroekaan/widgets/sliders/settings_slider.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';
import 'package:kortebroekaan/widgets/toggles/settings_toggle.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

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

  late StreamSubscription _subscription;

  bool _pendingPurchase = false;

  @override
  void initState() {
    super.initState();
    _subscription = InAppPurchasesProvider.stream.listen((list) {
      for (final purchase in list) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          setState(() {
            _pendingPurchase = false;
          });
          ModalShower.showModalSheet(
            context,
            PurchaseOkSheet(
              shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
            ),
          );
          return;
        }
        if (purchase.status == PurchaseStatus.pending) {
          setState(() {
            _pendingPurchase = true;
          });
        }
        if (purchase.status == PurchaseStatus.error) {
          setState(() {
            _pendingPurchase = false;
          });
          ModalShower.showModalSheet(
            context,
            PurchaseFailedSheet(
              shortPants: widget.weatherModel.dailyForecast[0].shortPants(),
            ),
          );
        }
      }
    });
  }

  Future<void> _getTime() async {
    WeatherModel buffer = widget.weatherModel;
    Color lightColor =
        AppColors.shortPantsLightColor(buffer.dailyForecast[0].shortPants());
    Color darkColor =
        AppColors.shortPantsDarkColor(buffer.dailyForecast[0].shortPants());
    Color darkColorException = AppColors.shortPantsDarkColorException(
        buffer.dailyForecast[0].shortPants());

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: SharedPreferencesProvider.notificationTime,
      helpText: "",
      builder: (context, widget) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(darkColor),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: lightColor,
              hourMinuteTextColor: darkColor,
              hourMinuteColor: darkColor.withAlpha(30),
              dayPeriodTextColor: darkColor,
              dayPeriodColor: lightColor,
              dialHandColor: darkColor,
              dialBackgroundColor: lightColor,
              dialTextColor: darkColor,
              entryModeIconColor: darkColor,
            ),
          ),
          child: widget!,
        );
      },
    );
    if (time == null) return;
    setState(() {
      SharedPreferencesProvider.notificationTime = time;
    });
    SharedPreferencesProvider.save();
    NotificationProvider.register();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shortPantsDarkColor(
          widget.weatherModel.dailyForecast[0].shortPants()),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            if (_pendingPurchase)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.shortPantsLightColor(
                        widget.weatherModel.dailyForecast[0].shortPants())
                    .withAlpha(100),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.shortPantsDarkColor(
                        widget.weatherModel.dailyForecast[0].shortPants()),
                  ),
                ),
              ),
            AbsorbPointer(
              absorbing: _pendingPurchase,
              child: SafeArea(
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
                                widget.weatherModel.dailyForecast[0]
                                    .shortPants(),
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
                      P(
                        text: translate("_screens._settings_screen.language"),
                        color: AppColors.shortPantsLightColor(
                          widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: AppColors.shortPantsDarkColor(
                            widget.weatherModel.dailyForecast[0].shortPants(),
                          ),

                        ),
                        child: LanguagePickerDropdown(
                          itemBuilder: (lang) => P(
                            text: lang.name,
                            color: AppColors.shortPantsLightColor(
                              widget.weatherModel.dailyForecast[0].shortPants(),
                            ),
                          ),
                          initialValue:
                              Language.fromIsoCode(SharedPreferencesProvider.language),
                          languages: SharedPreferencesProvider.languages
                              .map((e) => Language.fromIsoCode(e))
                              .toList(),
                          onValuePicked: (lang) {
                            SharedPreferencesProvider.language = lang.isoCode;
                            SharedPreferencesProvider.save();
                            setState(() {
                              changeLocale(context, lang.isoCode);
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SettingsSlider(
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                        onUpdate: _update,
                        bottomSheet: FilterInformationSheet(
                          shortPants:
                              widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SettingsToggle(
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                        firstOption:
                            translate("_screens._settings_screen._theme.dark"),
                        secondOption:
                            translate("_screens._settings_screen._theme.light"),
                        title:
                            translate("_screens._settings_screen._theme.title"),
                        preferencesName: "darkMode",
                        onUpdate: _update,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SettingsToggle(
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                        firstOption: "°C",
                        secondOption: "ºF",
                        title:
                            translate("_screens._settings_screen._unit.title"),
                        preferencesName: "celcius",
                        onUpdate: _update,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SettingsToggle(
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                        firstOption: translate(
                            "_screens._settings_screen._notifications.on"),
                        secondOption: translate(
                            "_screens._settings_screen._notifications.off"),
                        title: translate(
                            "_screens._settings_screen._notifications.title"),
                        preferencesName: "notifications",
                        onUpdate: _update,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      if (SharedPreferencesProvider.notifications)
                        CustomButton(
                          text: translate(
                              "_screens._settings_screen.set_notification_time",
                              args: {
                                "current":
                                    "${StringUtils.addLeadingZeroIfNeeded(SharedPreferencesProvider.notificationTime.hour)}:${StringUtils.addLeadingZeroIfNeeded(SharedPreferencesProvider.notificationTime.minute)}",
                              }),
                          buttonColor: AppColors.shortPantsLightColor(
                            widget.weatherModel.dailyForecast[0].shortPants(),
                          ),
                          textColor: AppColors.shortPantsDarkColor(
                            widget.weatherModel.dailyForecast[0].shortPants(),
                          ),
                          onPressed: _getTime,
                        ),
                      SettingsButton(
                        buttonText: translate(
                            "_screens._settings_screen.reset_location"),
                        onTap: () {
                          SharedPreferencesProvider.removeLocationSettings();
                          ScreenPusher.pushScreen(
                              context, const SplashScreen(), true);
                        },
                        buttonColor: AppColors.shortPantsLightColor(
                          widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                        textColor: AppColors.shortPantsDarkColor(
                          widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                      ),
                      SettingsButton(
                        buttonText: translate(
                            "_screens._settings_screen.restore_purchases"),
                        onTap: () {
                          InAppPurchase.instance.restorePurchases();
                        },
                        buttonColor: AppColors.shortPantsLightColor(
                          widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                        textColor: AppColors.shortPantsDarkColor(
                          widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                      ),
                      if (!SharedPreferencesProvider.removeAdsPurchased)
                        SettingsButton(
                          buttonText:
                              translate("_screens._settings_screen.remove_ads"),
                          onTap: () {
                            PurchaseParam param = PurchaseParam(
                              productDetails: InAppPurchasesProvider.products
                                  .firstWhere(
                                      (product) => product.id == "remove_ads"),
                            );
                            InAppPurchase.instance
                                .buyNonConsumable(purchaseParam: param);
                          },
                          buttonColor: AppColors.shortPantsLightColor(
                            widget.weatherModel.dailyForecast[0].shortPants(),
                          ),
                          textColor: AppColors.shortPantsDarkColor(
                            widget.weatherModel.dailyForecast[0].shortPants(),
                          ),
                        ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          SvgButton(
                            url:
                                "https://github.com/InstantlyMoist/KorteBroekAan_app/",
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
