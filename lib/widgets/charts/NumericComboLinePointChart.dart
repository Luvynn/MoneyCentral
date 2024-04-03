import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class NumericComboLinePointChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool? animate;

  NumericComboLinePointChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory NumericComboLinePointChart.withSampleData() {
    print("Inside Charts");
    return new NumericComboLinePointChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new charts.BarChart(seriesList,
            animate: animate,
            animationDuration: Duration(seconds: 2),
            // Configure the default renderer as a line renderer. This will be used
            // for any series that does not define a rendererIdKey.
            defaultRenderer: new charts.BarRendererConfig(),
            // Custom renderer configuration for the point series.
            customSeriesRenderers: [
              new charts.PointRendererConfig(
                // ID used to link series to this renderer.
                  customRendererId: 'customPoint')
            ]),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createSampleData() {
    final desktopSalesData = [
      new LinearSales('JUN', 50),
      new LinearSales('JUL', 75),
      new LinearSales('AUG', 200),
      new LinearSales('SEP', 175),
    ];

    final tableSalesData = [
      new LinearSales('JUN', 10),
      new LinearSales('JUL', 50),
      new LinearSales('AUG', 200),
      new LinearSales('SEP', 150),
    ];

    final mobileSalesData = [
      new LinearSales('JUN', 10),
      new LinearSales('JUL', 50),
      new LinearSales('AUG', 200),
      new LinearSales('SEP', 150),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        // Ensuring String return type
        measureFn: (LinearSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<LinearSales, String>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        // Ensuring String return type
        measureFn: (LinearSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      new charts.Series<LinearSales, String>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        // Ensuring String return type
        measureFn: (LinearSales sales, _) => sales.sales,
        data: mobileSalesData,
      )
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final String year;
  final int sales;

  LinearSales(this.year, this.sales);
}
