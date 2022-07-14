import 'package:flutter/material.dart';

class ImageGrayscaler {
  static Widget getGrayScaled(bool grey, Image image) {
    if (!grey) return image;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(
        <double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      child: image,
    );
  }
}
