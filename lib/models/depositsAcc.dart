import 'package:flutter/material.dart';

class DepositsAcc {
  String accno;
  String bankName;
  String principal;
  String maturity;
  String rate;
  String term;
  String key;

  DepositsAcc({
    required this.key,
    required this.accno,
    required this.principal,
    required this.term,
    required this.bankName,
    required this.rate,
    this.maturity = "0", // Assuming maturity can have a default value
  });

  // Assuming 'key' is also part of the JSON, you might want to adjust accordingly
  DepositsAcc.fromJson(String key, Map<String, dynamic> data)
      : key = key,
        accno = data['accno'],
        bankName = data['bankName'],
        principal = data['principal'].toString(),
        maturity = data['maturity']?.toString() ?? "0", // Provide a fallback value
        rate = data['rate'].toString(),
        term = data['term'].toString();

  Map<String, dynamic> toJson() => {
    'accno': accno,
    'bankName': bankName,
    'principal': principal,
    'maturity': maturity,
    'rate': rate,
    'term': term,
    'key': key,
  };
}
