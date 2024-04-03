import 'package:flutter/material.dart';

class Expense {
  String title;
  String category;
  String amount;
  String createdAt;
  String note;
  String key;

  Expense({
    required this.title,
    required this.amount,
    required this.key,
    required this.createdAt,
    this.category = "", // Default empty string for optional field
    this.note = "", // Default empty string for optional field
  });

  Expense.fromJson(String key, Map<String, dynamic> data)
      : key = key,
        title = data['title'],
        category = data['category'] ?? "", // Provide a default value if null
        amount = data['amount'].toString(),
        createdAt = data['createdAt'].toString(),
        note = data['note'] ?? ""; // Provide a default value if null

  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'amount': amount,
    'createdAt': createdAt,
    'note': note,
    'key': key,
  };


}
