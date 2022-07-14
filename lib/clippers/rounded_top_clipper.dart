import 'package:flutter/material.dart';

class RoundedTopClipper extends CustomClipper<Path> {
  RoundedTopClipper(this.scrollPos);

  ///The height of the arc
  double scrollPos;

  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(size.width, 80 * scrollPos);
    path.cubicTo(
        size.width * 0.6252278,
        200 * -0.02074785,
        size.width * 0.3747722,
        200 * -0.02074785,
        0,
        80 * scrollPos);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 80 * scrollPos);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    RoundedTopClipper old = oldClipper as RoundedTopClipper;
    return old.scrollPos != scrollPos;
  }
}