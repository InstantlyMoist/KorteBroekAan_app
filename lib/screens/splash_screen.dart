import 'package:flutter/material.dart';
import 'package:kortebroekaan/enums/loading_error_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    load(onSuccess: () {
      Navigator.pushReplacementNamed(context, '/home');
    }, onError: (loadingErrorState) {

    });
  }

  // Add callback
  Future<void> load({required onSuccess, required Function(LoadingErrorState loadingErrorState) onError}) async {

    await Future.delayed(const Duration(seconds: 1), () {
      onSuccess();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Splash Screen'),
      )
    );
  }
}
