import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/short_pants_data.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/database_provider.dart';
import 'package:kortebroekaan/providers/home_widget_provider.dart';
import 'package:kortebroekaan/providers/share_provider.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/screens/game_screen.dart';
import 'package:kortebroekaan/screens/settings_screen.dart';
import 'package:kortebroekaan/utils/home_screen_string_getter.dart';
import 'package:kortebroekaan/utils/image_grayscaler.dart';
import 'package:kortebroekaan/utils/modal_shower.dart';
import 'package:kortebroekaan/utils/screen_pusher.dart';
import 'package:kortebroekaan/widgets/buttons/custom_button.dart';
import 'package:kortebroekaan/widgets/containers/daily_forecast_container.dart';
import 'package:kortebroekaan/widgets/containers/home_container.dart';
import 'package:kortebroekaan/widgets/containers/hourly_forecast_container.dart';
import 'package:kortebroekaan/widgets/home/chart.dart';
import 'package:kortebroekaan/widgets/home/image_wrapper.dart';
import 'package:kortebroekaan/widgets/home/rotating_icon.dart';
import 'package:kortebroekaan/widgets/rows/info_row.dart';
import 'package:kortebroekaan/widgets/buttons/round_button.dart';
import 'package:kortebroekaan/widgets/sheets/uv_index_sheet.dart';
import 'package:kortebroekaan/widgets/sheets/webshop_sheet.dart';
import 'package:kortebroekaan/widgets/home_screen_background.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';
import 'package:kortebroekaan/widgets/text/pTiny.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.weatherModel}) : super(key: key);

  final WeatherModel weatherModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  InterstitialAd? _ad;
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  final ScrollController _controller = ScrollController();

  final ValueNotifier<int> _graphRefresher = ValueNotifier<int>(0);

  late StreamSubscription<DatabaseEvent> _counterSubscription;

  DateTime _lastPress = DateTime.now();
  int _presses = 0;

  void _shake() {
    if (_lastPress.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch - 1000) {
      _lastPress = DateTime.now();
      return;
    }
    _lastPress = DateTime.now();
    _presses++;
    if (_presses > 5) {
      _shakeController.forward(from: 0);
      Vibrate.vibrate();
    }
    if (_presses > 10) {
      ScreenPusher.pushScreen(
          context, GameScreen(weatherModel: widget.weatherModel), true);
      // Go to a new screen
    }
  }

  void _loadAds() async {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-1364717858891314/5606978841'
          : 'ca-app-pub-1364717858891314/4155643835',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _ad = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _ad = null;
        },
      ),
    );
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-1364717858891314/6730862092'
          : 'ca-app-pub-1364717858891314/8968986812',
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _bannerAdLoaded = true;
        });
      }),
    );

    if (_bannerAd != null && !SharedPreferencesProvider.removeAdsPurchased) {
      _bannerAd!.load();
    }
  }

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this);
    _updateWidget();

    _loadAds();

    _counterSubscription = DatabaseProvider.counterRef.limitToLast(1).onChildChanged.listen((event) {
      String lastKey = event.snapshot.key!;
      int yes = (event.snapshot.child("yes").value ?? 0) as int;
      int no = (event.snapshot.child("no").value ?? 0) as int;

      if (DatabaseProvider.yesData.isEmpty || DatabaseProvider.yesData.last.date != lastKey) {
        DatabaseProvider.yesData.add(ShortPantsData(lastKey, yes));
        DatabaseProvider.noData.add(ShortPantsData(lastKey, no));
      } else {
        DatabaseProvider.yesData.last.amount = yes;
        DatabaseProvider.noData.last.amount = no;
      }

      _graphRefresher.value++;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _counterSubscription.cancel();
  }

  void _incrementCounter(bool shortPants) {
    // Get start of next day
    DateTime now = DateTime.now();
    DateTime nextDay = DateTime(now.year, now.month, now.day + 1);
    setState(() {
      SharedPreferencesProvider.canVoteIn = nextDay;
      SharedPreferencesProvider.save();
      DatabaseProvider.increment(shortPants);
    });
  }

  void _updateWidget() async {
    HomeWidgetProvider.updateWidget(
        widget.weatherModel.dailyForecast[0].shortPants());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double maxScrollHeight = MediaQuery.of(context).size.height / 2;

    _controller.addListener(() {
      _scrollNotifier.value =
          1 - (_controller.offset / maxScrollHeight).clamp(0, 1);
    });
  }

  bool shown = false;
  final ValueNotifier<double> _scrollNotifier = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (shown) return;
      shown = true;
      if (!SharedPreferencesProvider.webshopMessageSeen) {
        ModalShower.showModalSheet(
            context,
            WebshopSheet(
                darkColor: AppColors.shortPantsDarkColor(
                    widget.weatherModel.dailyForecast[0].shortPants()),
                lightColor: AppColors.shortPantsLightColor(
                    widget.weatherModel.dailyForecast[0].shortPants())));
      }
    });
    return Scaffold(
      backgroundColor: AppColors.shortPantsDarkColor(
          widget.weatherModel.dailyForecast[0].shortPants()),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                      bottom: 16 * (1 - _scrollNotifier.value)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H1(
                        text: translate("_screens._home_screen.title"),
                        color: AppColors.shortPantsLightColor(
                          widget.weatherModel.dailyForecast[0].shortPants(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InfoRow(
                        icon: Icons.location_on_outlined,
                        data:
                            "${widget.weatherModel.cityName} | ${widget.weatherModel.countryName}",
                        color: AppColors.shortPantsLightColor(
                            widget.weatherModel.dailyForecast[0].shortPants()),
                      ),
                      InfoRow(
                        icon: Icons.water_drop_outlined,
                        data: translate(
                          "_screens._home_screen.rain_chance",
                          args: {
                            "chance": widget
                                .weatherModel.dailyForecast[0].rainChance
                                .toString()
                          },
                        ),
                        color: AppColors.shortPantsLightColor(
                            widget.weatherModel.dailyForecast[0].shortPants()),
                      ),
                      InfoRow(
                        icon: Icons.thermostat_rounded,
                        data: widget.weatherModel.dailyForecast[0]
                            .temperatureParsedString(),
                        color: AppColors.shortPantsLightColor(
                            widget.weatherModel.dailyForecast[0].shortPants()),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RoundButton(
                            data: Icons.settings,
                            onPressed: () async => ScreenPusher.pushScreen(
                                    context,
                                    SettingsScreen(
                                      weatherModel: widget.weatherModel,
                                      onUpdate: () => setState(() {}),
                                    ),
                                    false)
                                .then((value) async {
                              setState(() {});
                              if (_ad != null) {
                                if (!SharedPreferencesProvider.adShown &&
                                    !SharedPreferencesProvider
                                        .removeAdsPurchased) {
                                  SharedPreferencesProvider.adShown = true;
                                  _ad!.show();
                                }
                              }
                            }),
                            shortPants: widget.weatherModel.dailyForecast[0]
                                .shortPants(),
                          ),
                          const Spacer(),
                          RoundButton(
                            data: Icons.share,
                            onPressed: () => ShareProvider.share(
                                widget.weatherModel, context),
                            shortPants: widget.weatherModel.dailyForecast[0]
                                .shortPants(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                HomeScreenBackground(
                  scrollPos: _scrollNotifier,
                  color: AppColors.shortPantsLightColor(
                      widget.weatherModel.dailyForecast[0].shortPants()),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      RotatingIcon(
                        rotationNotifier: _scrollNotifier,
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                        onTap: () {
                          _controller.animateTo(
                            _scrollNotifier.value == 1
                                ? MediaQuery.of(context).size.height / 2
                                : 0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: _shake,
                        child: ShakeWidget(
                          shakeConstant: ShakeHardConstant1(),
                          autoPlay: false,
                          onController: (controller) {
                            _shakeController = controller;
                          },
                          child: ImageWrapper(
                            shortPants: widget.weatherModel.dailyForecast[0]
                                .shortPants(),
                            rotationNotifier: _scrollNotifier,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16 + (32 * _scrollNotifier.value),
                      ),
                      Text(
                        translate(
                            "_forecasts.${widget.weatherModel.conditionCode}"),
                        style: TextStyle(
                          color: AppColors.shortPantsDarkColor(widget
                              .weatherModel.dailyForecast[0]
                              .shortPants()),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      HourlyForecastContainer(
                        model: widget.weatherModel,
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (_bannerAd != null &&
                          !SharedPreferencesProvider.removeAdsPurchased &&
                          _bannerAdLoaded)
                        Container(
                          alignment: Alignment.center,
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(
                            ad: _bannerAd!,
                          ),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      DailyForecastContainer(
                        shortPants:
                            widget.weatherModel.dailyForecast[0].shortPants(),
                        model: widget.weatherModel,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          HomeContainer(
                            shortPants: widget.weatherModel.dailyForecast[0]
                                .shortPants(),
                            onTap: () => ModalShower.showModalSheet(
                              context,
                              UvIndexSheet(
                                shortPants: widget.weatherModel.dailyForecast[0]
                                    .shortPants(),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      color: AppColors
                                          .shortPantsDarkColorException(widget
                                              .weatherModel.dailyForecast[0]
                                              .shortPants()),
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    PTiny(
                                      text: translate(
                                          "_screens._home_screen._tiles._sunscreen.title"),
                                      color: AppColors
                                          .shortPantsDarkColorException(
                                        widget.weatherModel.dailyForecast[0]
                                            .shortPants(),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Center(
                                  child: H1(
                                    text: translate(
                                      "_screens._home_screen._tiles._sunscreen.${HomeScreenStringGetter.sunScreen(widget.weatherModel.uv) ? "yes" : "no"}",
                                    ),
                                    color:
                                        AppColors.shortPantsDarkColorException(
                                      widget.weatherModel.dailyForecast[0]
                                          .shortPants(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                P(
                                  text: translate(
                                    "_screens._home_screen._tiles._sunscreen.uv_index",
                                    args: {
                                      "uv": widget.weatherModel.uv,
                                    },
                                  ),
                                  align: TextAlign.center,
                                  color: AppColors.shortPantsDarkColorException(
                                    widget.weatherModel.dailyForecast[0]
                                        .shortPants(),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          HomeContainer(
                            shortPants: widget.weatherModel.dailyForecast[0]
                                .shortPants(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.thermostat_rounded,
                                      color: AppColors
                                          .shortPantsDarkColorException(widget
                                              .weatherModel.dailyForecast[0]
                                              .shortPants()),
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    PTiny(
                                      text: translate(
                                          "_screens._home_screen._tiles._temperature.title"),
                                      color: AppColors
                                          .shortPantsDarkColorException(
                                        widget.weatherModel.dailyForecast[0]
                                            .shortPants(),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Center(
                                  child: H1(
                                    text: widget.weatherModel
                                        .temperatureParsedString(),
                                    color:
                                        AppColors.shortPantsDarkColorException(
                                      widget.weatherModel.dailyForecast[0]
                                          .shortPants(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                P(
                                  text: translate(
                                    "_screens._home_screen._tiles._temperature.${widget.weatherModel.dailyForecast[0].shortPants() ? "yes" : "no"}",
                                  ),
                                  align: TextAlign.center,
                                  color: AppColors.shortPantsDarkColorException(
                                    widget.weatherModel.dailyForecast[0]
                                        .shortPants(),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.lighter(widget
                              .weatherModel.dailyForecast[0]
                              .shortPants()),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SharedPreferencesProvider
                                      .canVoteIn!.millisecondsSinceEpoch <
                                  DateTime.now().millisecondsSinceEpoch
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    P(
                                      text: translate(
                                          "_screens._home_screen._graph.title"),
                                      color: AppColors
                                          .shortPantsDarkColorException(
                                        widget.weatherModel.dailyForecast[0]
                                            .shortPants(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    PTiny(
                                      text: translate(
                                          "_screens._home_screen._graph.text"),
                                      color: AppColors
                                          .shortPantsDarkColorException(
                                        widget.weatherModel.dailyForecast[0]
                                            .shortPants(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomButton(
                                      text: translate(
                                          "_screens._home_screen._graph.no"),
                                      buttonColor:
                                          AppColors.shortPantsLightColor(widget
                                              .weatherModel.dailyForecast[0]
                                              .shortPants()),
                                      textColor: AppColors.shortPantsDarkColor(
                                          widget.weatherModel.dailyForecast[0]
                                              .shortPants()),
                                      onPressed: () => _incrementCounter(false),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomButton(
                                      text: translate(
                                          "_screens._home_screen._graph.yes"),
                                      buttonColor:
                                          AppColors.shortPantsLightColor(widget
                                              .weatherModel.dailyForecast[0]
                                              .shortPants()),
                                      textColor: AppColors.shortPantsDarkColor(
                                          widget.weatherModel.dailyForecast[0]
                                              .shortPants()),
                                      onPressed: () => _incrementCounter(true),
                                    ),
                                  ],
                                )
                              : PantsChart(
                                  color: AppColors.shortPantsDarkColorException(
                                    widget.weatherModel.dailyForecast[0]
                                        .shortPants(),
                                  ),
                                  refresh: _graphRefresher,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
