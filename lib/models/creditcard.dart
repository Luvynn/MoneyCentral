import 'package:awesomeapp/models/creditcard.dart';
import 'package:flutter/material.dart';

class CreditCard {
  String bankName;
  String cardNumber;
  String cvv;
  String expiryMonth;
  String expiryYear;
  String nameOnCard;
  String? key;

  CreditCard({
    required this.bankName,
    required this.cardNumber,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
    required this.nameOnCard,
    this.key
  });

  // Use named parameters for clarity and consistency
/*
  CreditCard.fromJson({
    required String key,
    required Map<String, dynamic> data,
  })  : key = key,
        bankName = data['bankName'],
        cardNumber = data['cardNumber'],
        cvv = data['cvv'],
        expiryMonth = data['expiryMonth'].toString(),
        expiryYear = data['expiryYear'].toString(),
        nameOnCard = data["nameOnCard"];
*/

  CreditCard.fromJson(String key, Map<String, dynamic> data)
      : key = key,
        bankName = data['bankName'],
        cardNumber = data['cardNumber'],
        cvv = data['cvv']?? '0',
        expiryMonth = data['expiryMonth'].toString(),
        expiryYear = data['expiryYear'].toString(),
        nameOnCard = data["nameOnCard"];


  Map<String, dynamic> toJson() => {
    'bankName': bankName,
    'cardNumber': cardNumber,
    'cvv': cvv,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'nameOnCard': nameOnCard,
    'key': key,
  };
}
