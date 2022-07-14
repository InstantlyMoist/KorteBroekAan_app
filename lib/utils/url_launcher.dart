import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static void launch(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $uri';
  }
}
