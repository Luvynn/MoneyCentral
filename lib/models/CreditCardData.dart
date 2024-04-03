import 'package:charts_flutter/flutter.dart' as charts;
import 'package:random_color/random_color.dart';
import 'package:flutter/material.dart';

class CreditCardData {
  final int id;
  final int count;
  final charts.Color color; // Consider whether you need this to be mutable
  final String name;
  final int total;

  CreditCardData(this.id, this.count, this.name, this.total)
      : color = _getRandomColor(); // Initialize color directly if immutable

  static charts.Color _getRandomColor() {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(colorHue: ColorHue.blue);
    // Directly access ARGB components to create a charts.Color object
    return charts.Color(a: _color.alpha, r: _color.red, g: _color.green, b: _color.blue);
  }
}
