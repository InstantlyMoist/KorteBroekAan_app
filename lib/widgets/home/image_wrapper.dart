import 'package:flutter/material.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:kortebroekaan/utils/image_grayscaler.dart';

class ImageWrapper extends StatefulWidget {
  const ImageWrapper(
      {Key? key, required this.rotationNotifier, required this.shortPants})
      : super(key: key);

  final ValueNotifier<double> rotationNotifier;
  final bool shortPants;

  @override
  State<ImageWrapper> createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {

  @override
  void initState() {
    super.initState();

    widget.rotationNotifier.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return ImageGrayscaler.getGrayScaled(
      SharedPreferencesProvider.darkMode,
      Image(
        image: AssetImage(
          'assets/images/${widget.shortPants ? "yes-man" : "no-man"}.png',
        ),
        height: 270,
        width: 150 + (50 * widget.rotationNotifier.value),
      ),
    );
  }
}
