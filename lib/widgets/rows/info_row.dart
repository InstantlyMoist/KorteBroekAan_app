import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  InfoRow(
      {Key? key, required this.icon, required this.data, required this.color})
      : super(key: key);

  IconData icon;
  String data;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              data,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
