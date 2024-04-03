import 'package:flutter/material.dart';

class CCExpense {
  String title;
  String amount;
  String category;
  String creditCardName;
  String? createdAt;
  String? note;
  String? key;

  CCExpense(this.title, this.category, this.amount, this.creditCardName, createdAt, note, key );

  /*factory CCExpense.fromJson(Map<String, dynamic> data) {
    return CCExpense(
      data['title'] ?? '', // Providing default values in case the key does not exist
      data['amount'].toString(),
      data['category'] ?? '',
      data['creditCardName'] ?? '',
      data['createdAt']?.toString(),
      data['note'],
      data['key'],
    );
  }
*/
  CCExpense.fromJson(String key, Map<String, dynamic> data)
      : key = key,
        title = data['title'],
        category = data['category'] ?? "", // Provide a default value if null
        amount = data['amount'].toString(),
        createdAt = data['createdAt'].toString(),
        note = data['note'] ?? "", // Provide a default value if null
        creditCardName = data['creditCardName'].toString()?? '';


  Map<String, dynamic> toJson() {
    return {
    'title': title,
    'category': category,
    'amount': amount,
    'createdAt': createdAt,
    'note': note,
    'key': key,
    'creditCardName': creditCardName
    };
  }
}
