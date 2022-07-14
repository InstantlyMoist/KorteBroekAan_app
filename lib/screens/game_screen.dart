import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/weather_model.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/screens/home_screen.dart';
import 'package:kortebroekaan/utils/image_grayscaler.dart';
import 'package:kortebroekaan/utils/screen_pusher.dart';
import 'package:kortebroekaan/widgets/containers/game_barrier.dart';
import 'package:kortebroekaan/widgets/text/h1.dart';
import 'package:kortebroekaan/widgets/text/p.dart';
import 'package:share_plus/share_plus.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key? key, required this.weatherModel}) : super(key: key);

  WeatherModel weatherModel;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 1),
  );

  // Bird
  double _birdWidth = 0.07;
  double _birdHeight = 0.07;
  double _birdY = 0;
  double _initialPosition = 0;
  double _initialRotation = 0;
  double _time = 0;
  double _height = 0;
  double _rot = 0;
  double _gravity = -4.9;
  double _velocity = 2.2;

  Matrix4 _rotation = Matrix4.identity();

  // Barriers
  double _barrierGap = 1.0;
  List<double> _barrierX = [2, 3.5];
  double _barrierWidth = 0.5;
  List<List<double>> _barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  bool _started = false;
  int _score = 0;
  bool _scored = false;

  void _startGame() {
    _started = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _height = _gravity * _time * _time + _velocity * _time;
      _rot = _height;
      setState(() {
        _birdY = _initialPosition - _height;

        //_rotation.setTranslationRaw(0, 50, 0);
        _rotation = Matrix4.rotationZ(_initialRotation - _rot);

        for (int i = 0; i < _barrierX.length; i++) {
          _barrierX[i] -= 0.01;
          if (_barrierX[i] < -1.0) {
            _barrierX[i] = 2; // Regenate barrier heights
            _barrierHeight[i][0] = Random().nextDouble();
            _barrierHeight[i][1] = 2 - (_barrierHeight[i][0] + _barrierGap);
          }
        }
      });

      if (_dead()) {
        timer.cancel();
        _started = false;
        _reset();
      }

      _time += 0.01;
    });
  }

  void _reset() {
    _birdY = 0;
    _started = false;
    _time = 0;
    _initialPosition = 0;
    _initialRotation = 0;
    _rot = 0;
    _rotation = Matrix4.rotationZ(0);
    _barrierX = [2, 3.5];
    _scored = false;
    if (_score > SharedPreferencesProvider.topScore) {
      SharedPreferencesProvider.topScore = _score;
      SharedPreferencesProvider.save();
      _confettiController.play();
    }
    _score = 0; // Save the score (?)
  }

  bool _dead() {
    if (_birdY < -1 || _birdY > 1) return true;
    bool inRange = false;
    for (int i = 0; i < _barrierX.length; i++) {
      if (_barrierX[i] <= _birdWidth &&
          _barrierX[i] + _barrierWidth >= -_birdWidth) {
        if (_birdY <= -1 + _barrierHeight[i][0] ||
            _birdY + _birdHeight >= 1 - _barrierHeight[i][1]) {
          return true;
        }
        inRange = true;
      }
    }
    if (!_scored && inRange) {
      _scored = true;
      _score++;
    }
    if (_scored && !inRange) {
      _scored = false;
    }
    return false;
  }

  void _jump() {
    setState(() {
      _time = 0;
      _initialPosition = _birdY;
      _initialRotation = _rot;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logEvent(
      name: "easter_egg_found",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScreenPusher.pushScreen(
            context, HomeScreen(weatherModel: widget.weatherModel), true);
        return false;
      },
      child: GestureDetector(
        onTap: _started ? _jump : _startGame,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.shortPantsLightColor(
                    widget.weatherModel.dailyForecast[0].shortPants(),
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment(0, _birdY),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Transform(
                              transform: _rotation,
                              alignment: FractionalOffset.center,
                              child: ImageGrayscaler.getGrayScaled(
                                SharedPreferencesProvider.darkMode,
                                Image(
                                  image: AssetImage(
                                    "assets/images/${widget.weatherModel.dailyForecast[0].shortPants() ? "yes" : "no"}-pants.png",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Container(
                            alignment: const Alignment(0, -0.5),
                            child: Text(
                              _started
                                  ? ""
                                  : translate("_easter_egg.tap_to_play"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.shortPantsDarkColor(
                                  widget.weatherModel.dailyForecast[0]
                                      .shortPants(),
                                ),
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        GameBarrier(
                          shortPants:
                              widget.weatherModel.dailyForecast[0].shortPants(),
                          x: _barrierX[0],
                          width: _barrierWidth,
                          height: _barrierHeight[0][0],
                          bottom: false,
                        ),
                        GameBarrier(
                          shortPants:
                              widget.weatherModel.dailyForecast[0].shortPants(),
                          x: _barrierX[0],
                          width: _barrierWidth,
                          height: _barrierHeight[0][1],
                          bottom: true,
                        ),
                        GameBarrier(
                          shortPants:
                              widget.weatherModel.dailyForecast[0].shortPants(),
                          x: _barrierX[1],
                          width: _barrierWidth,
                          height: _barrierHeight[1][0],
                          bottom: false,
                        ),
                        GameBarrier(
                          shortPants:
                              widget.weatherModel.dailyForecast[0].shortPants(),
                          x: _barrierX[1],
                          width: _barrierWidth,
                          height: _barrierHeight[1][1],
                          bottom: true,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirection: 1.7,
                            particleDrag: 0.05,
                            // apply drag to the confetti
                            emissionFrequency: 0,
                            // how often it should emit
                            numberOfParticles: 20,
                            // number of particles to emit
                            gravity: 0.05,
                            // gravity - or fall speed
                            shouldLoop: false,
                            colors: widget.weatherModel.dailyForecast[0]
                                    .shortPants()
                                ? [
                                    Colors.white,
                                    AppColors.shortPantsDarkColor(true)
                                  ]
                                : [
                                    Colors.white,
                                    AppColors.shortPantsDarkColor(false)
                                  ], // manual
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.shortPantsDarkColor(
                    widget.weatherModel.dailyForecast[0].shortPants(),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        P(
                          text: translate("_easter_egg.score",
                              args: {"score": _score}),
                          color: AppColors.shortPantsLightColor(widget
                              .weatherModel.dailyForecast[0]
                              .shortPants()),
                        ),
                        P(
                          text: translate("_easter_egg.top_score", args: {
                            "topscore": SharedPreferencesProvider.topScore
                          }),
                          color: AppColors.shortPantsLightColor(widget
                              .weatherModel.dailyForecast[0]
                              .shortPants()),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
