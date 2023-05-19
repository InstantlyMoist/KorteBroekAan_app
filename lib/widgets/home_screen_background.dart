import 'package:flutter/material.dart';
import 'package:kortebroekaan/clippers/rounded_top_clipper.dart';

class HomeScreenBackground extends StatefulWidget {
  const HomeScreenBackground(
      {Key? key, required this.scrollPos, required this.color})
      : super(key: key);

  final ValueNotifier<double> scrollPos;
  final Color color;

  @override
  State<HomeScreenBackground> createState() => _HomeScreenBackgroundState();
}

class _HomeScreenBackgroundState extends State<HomeScreenBackground> {
  double _oldPos = 1;

  @override
  void initState() {
    super.initState();
    widget.scrollPos.addListener(() {
      // Minimal difference should be 1 before we update the state
      if ((widget.scrollPos.value - _oldPos).abs() < 0.05) return;
      _oldPos = widget.scrollPos.value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipPath(
        clipper: RoundedTopClipper(widget.scrollPos.value),
        child: Container(
          color: widget.color,
          width: double.infinity,
        ),
      ),
    );
  }
}
