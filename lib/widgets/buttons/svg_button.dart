import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kortebroekaan/utils/modal_shower.dart';
import 'package:kortebroekaan/widgets/sheets/url_launcher_sheet.dart';

class SvgButton extends StatelessWidget {
  SvgButton({
    Key? key,
    required this.assetName,
    required this.url,
    required this.lightColor,
    required this.darkColor,
  }) : super(key: key);

  String url;
  String assetName;
  Color lightColor;
  Color darkColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ModalShower.showModalSheet(
        context,
        UrlLauncherSheet(
          darkColor: darkColor,
          lightColor: lightColor,
          url: url,
        ),
      ),
      child: SvgPicture.asset(
        assetName,
        color: lightColor,
        width: 38,
      ),
    );
  }
}
