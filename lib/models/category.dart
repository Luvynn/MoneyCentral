import 'package:flutter/material.dart';

class Category {
  String id;
  String name;
  IconData? icon; // Make icon nullable
  bool show = true;

  // Making icon optional but requiring an explicit named parameter to enhance clarity
  Category(this.id, this.name, {this.icon});

  // This constructor ensures 'id' is initialized. We'll use a named constructor with initializers
  Category.fromJson(String key, Map<String, dynamic> value)
      : id = key,
        name = value["name"] {
    // 'id' and 'name' are initialized using initializer list
    // Additional processing if necessary. Icon handling still needs a mapping strategy
  }

  void updateVisibility(bool value) {
    show = value;
  }
}
