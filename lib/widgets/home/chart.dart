import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/constants/app_colors.dart';
import 'package:kortebroekaan/models/short_pants_data.dart';
import 'package:kortebroekaan/providers/database_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PantsChart extends StatefulWidget {
  const PantsChart({Key? key, required this.color, required this.refresh})
      : super(key: key);

  final Color color;
  final ValueNotifier<int> refresh;

  @override
  State<PantsChart> createState() => _PantsChartState();
}

class _PantsChartState extends State<PantsChart> {
  @override
  void initState() {
    super.initState();
    widget.refresh.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(
          color: widget.color,
        ),
      ),
      trackballBehavior: TrackballBehavior(enable: true),
      primaryXAxis: CategoryAxis(),
      series: <LineSeries<ShortPantsData, String>>[
        LineSeries<ShortPantsData, String>(
          legendItemText: translate("_screens._home_screen._graph.yes"),
          color: AppColors.shortPantsDarkColorException(
            true,
          ),
          dataSource: DatabaseProvider.yesData,
          xValueMapper: (ShortPantsData shortPants, _) => shortPants.date,
          yValueMapper: (ShortPantsData shortPants, _) => shortPants.amount,
        ),
        LineSeries<ShortPantsData, String>(
          dashArray: [5, 5],
          legendItemText: translate("_screens._home_screen._graph.no"),
          color: AppColors.shortPantsDarkColorException(
            false,
          ),
          dataSource: DatabaseProvider.noData,
          xValueMapper: (ShortPantsData shortPants, _) => shortPants.date,
          yValueMapper: (ShortPantsData shortPants, _) => shortPants.amount,
        ),
      ],
    );
  }
}
