import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:kortebroekaan/models/short_pants_data.dart';

class DatabaseProvider {
  static late DatabaseReference counterRef;

  static List<ShortPantsData> yesData = [];
  static List<ShortPantsData> noData = [];

  static Future<void> init() async {
    counterRef = FirebaseDatabase.instance.ref("days");

    DataSnapshot snapshot = await counterRef.limitToLast(7).get();
    List<DataSnapshot> children = snapshot.children.toList();

    for (DataSnapshot ds in children) {
      String key = ds.key!;
      List<DataSnapshot> timeSnapshot = ds.children.toList();
      int no = 0;
      int yes = 0;
      try {
        no = int.parse(timeSnapshot[0].value.toString());
      } catch (e) {}

      try {
        yes = int.parse(timeSnapshot[1].value.toString());
      } catch (e) {}

      yesData.add(ShortPantsData(key, yes));
      noData.add(ShortPantsData(key, no));
    }
  }

  static Future<void> increment(bool shortPants) async {
    DateFormat format = DateFormat("yyyy-MM-dd", "nl_NL");
    String date = format.format(DateTime.now());

    await counterRef.child(date).child(shortPants ? "yes" : "no").set(
          ServerValue.increment(1),
        );
  }
}
