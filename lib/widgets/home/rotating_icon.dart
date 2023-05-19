import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class RotatingIcon extends StatefulWidget {
  const RotatingIcon(
      {Key? key,
      required this.onTap,
      required this.rotationNotifier,
      required this.shortPants})
      : super(key: key);

  final VoidCallback onTap;
  final ValueNotifier rotationNotifier;
  final bool shortPants;

  @override
  State<RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon> {
  @override
  void initState() {
    super.initState();
    widget.rotationNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Transform.rotate(
        angle: (pi / 180) * (180 * (1 - widget.rotationNotifier.value)),
        child: Icon(
          Icons.keyboard_arrow_up_rounded,
          color: AppColors.shortPantsDarkColor(widget.shortPants),
          size: 50,
        ),
      ),
    );
  }
}
