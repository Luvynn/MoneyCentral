import 'package:charts_flutter/flutter.dart' as charts;
import 'package:random_color/random_color.dart';
import 'package:flutter/material.dart';


class CategoryData {
  final int id;
  final int count;
  charts.Color color = charts.Color.fromHex(code: "#00FF00");
  final String name;
  final int total;

  CategoryData(this.id, this.count, this.name, this.total) {
    this.color = _getRandomColor();
  }

  charts.Color _getRandomColor() {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(colorHue: ColorHue.blue);
    print('List size: ${_color}');
    // Directly use the ARGB values to create a charts.Color
    return charts.Color(
      a: _color.alpha,
      r: _color.red,
      g: _color.green,
      b: _color.blue,
    );
  }
}