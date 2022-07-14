import 'package:flutter/material.dart';
import 'package:kortebroekaan/constants/app_colors.dart';

class HomeContainer extends StatelessWidget {
  HomeContainer({Key? key, required this.shortPants, required this.child, this.onTap})
      : super(key: key);
  bool shortPants;
  Widget child;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AspectRatio(
        aspectRatio: 1,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lighter(shortPants),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox.expand(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
