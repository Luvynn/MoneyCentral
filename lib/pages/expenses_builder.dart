import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesomeapp/models/expense.dart';
import 'package:awesomeapp/models/ccExpense.dart';
import 'package:awesomeapp/models/savingsAcc.dart';
import 'package:awesomeapp/models/depositsAcc.dart';
import 'package:awesomeapp/models/creditcard.dart';
import 'package:awesomeapp/models/category.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/expenses/expense_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future<void> _loadData(MainModel model) async {
  DatabaseEvent event = await FirebaseDatabase.instance
      .reference()
      .child('users/${model.authenticatedUser?.uid}')
      .once();

  if (event.snapshot.exists && event.snapshot.value is Map) {
    Map<dynamic, dynamic> data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
    List<CCExpense> ccexpenses = [];
    List<Category> categories = [];
    String theme = '';
    String currency = '';
    String monthlyTarget = '';
    String yearlyTarget = '';
    String projectedSpending = '';
    String outstandingAccBal = '';
    print('start setting Expenses');
    data.forEach((key, value) {
      if (key == "expenses" && value is Map) {
        value.forEach((key, value) {
          ccexpenses.add(CCExpense.fromJson(key, value));
        });
      } else if (key == "preferences" && value is Map) {
        theme = value["theme"] ?? '';
        currency = value["currency"] ?? '';

        monthlyTarget = value["monthlyTarget"].toString() ?? '';
        yearlyTarget = value["yearlyTarget"].toString() ?? '';
        projectedSpending = value["projectedSpending"].toString() ?? '';
        outstandingAccBal = value["outstandingAccBal"].toString() ?? '';
        print('set monthly target');
        if (value.containsKey("userCategories") && value["userCategories"] is Map) {
          Map<dynamic, dynamic> categoryMap = value["userCategories"];
          categoryMap.forEach((key, value) {
            categories.add(Category.fromJson(key, value));
          });
        }
      }
    });
    print("Set model preferences");
    model.setPreferences(theme, currency, categories, monthlyTarget, yearlyTarget, projectedSpending, outstandingAccBal);
    if (ccexpenses.isNotEmpty) {
      model.setCCExpenses(ccexpenses);
    }
  } else {
    // Handle the case where data is not in the expected format or is missing.
    print("Data is not in the expected format or is missing");
  }
}


class ExpensesList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        if (model.syncStatus) {
          return ExpenseList();
        }
        return FutureBuilder<DatabaseEvent>(
          future: FirebaseDatabase.instance.ref('users/${model.authenticatedUser?.uid}')
              .once(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading data while getting Connection" + snapshot.error.toString()
              + model.authenticatedUser.toString()));
            }

            if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
              return Center(child: Text("No data found"));
            }

            // Safely cast the value to Map<dynamic, dynamic>
            Map<dynamic, dynamic>? dataMap;
            try {
              dataMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
              print(dataMap);
            } catch (e) {
              // Handle the case where casting is unsuccessful
              return Center(child: Text("Failed to cast data to map"));
            }

            if (dataMap == null) {
              // Handle the case where dataMap is null
              return Center(child: Text("Data is not in expected format"));
            }

            // Process the data
            print('process data');
            List<Expense> expenses = _parseExpenses(dataMap['expenses']);
            List<CCExpense> ccexpenses = _parseCCExpenses(dataMap['ccexpenses']);
            print('Credit Cards');
            print(dataMap['creditcards']);
            List<CreditCard> creditCards = _parseCreditCards(dataMap['creditcards']);

            List<SavingsAcc> savingsAcc = _parseSavingsAcc(dataMap['bankacs']['savings']);
            List<DepositsAcc> depositsAcc = _parseDepositsAcc(dataMap['bankacs']['deposits']);


            List<Category> categories = _parseCategories(dataMap['userCategories']);
            String theme = "darkTheme";
            String currency = "SGD";
            String monthlyTarget = '100';
            String yearlyTarget = '10000';
            String projectedSpending = '1000';
            String outstandingAccBal = '3000';

            // Update the model with the fetched data
            model.setPreferences(theme, currency, categories, monthlyTarget, yearlyTarget, projectedSpending, outstandingAccBal);
            model.setExpenses(expenses);
            model.setCCExpenses(ccexpenses);
            print('Savings Acc');
            print(savingsAcc);
            model.setSavingsAcc(savingsAcc);
            model.setDepositsAcc(depositsAcc);

            model.setCreditCard(creditCards);

            model.toggleSynced();
            return ExpenseList();
          },
        );
      },
    );
  }

  // Example parser method for expenses; similar methods should be created for other data types
  List<Expense> _parseExpenses(Map<dynamic, dynamic>? rawData) {
    if (rawData == null) return [];
    return rawData.entries.map((e) {
      // Assuming e.value is a Map<String, dynamic> that can be passed directly to Expense.fromJson
      // And assuming that Expense.fromJson expects a Map<String, dynamic>
      return Expense.fromJson(e.key, Map<String, dynamic>.from(e.value));
    }).toList();
  }
  List<SavingsAcc> _parseSavingsAcc(Map<dynamic, dynamic>? rawData) {
    if (rawData == null) return [];
    return rawData.entries.map((e) {
      // Assuming e.value is a Map<String, dynamic> that can be passed directly to Expense.fromJson
      // And assuming that Expense.fromJson expects a Map<String, dynamic>
      return SavingsAcc.fromJson(e.key, Map<String, dynamic>.from(e.value));
    }).toList();
  }

  List<DepositsAcc> _parseDepositsAcc(Map<dynamic, dynamic>? rawData) {
    if (rawData == null) return [];
    return rawData.entries.map((e) {
      // Assuming e.value is a Map<String, dynamic> that can be passed directly to Expense.fromJson
      // And assuming that Expense.fromJson expects a Map<String, dynamic>
      return DepositsAcc.fromJson(e.key, Map<String, dynamic>.from(e.value));
    }).toList();
  }
  List<CCExpense> _parseCCExpenses(Map<dynamic, dynamic>? rawData) {
    if (rawData == null) return [];
    return rawData.entries.map((e) {
      // Assuming e.value is a Map<String, dynamic> that can be passed directly to Expense.fromJson
      // And assuming that Expense.fromJson expects a Map<String, dynamic>
      return CCExpense.fromJson(e.key, Map<String, dynamic>.from(e.value));
    }).toList();
  }

  // Placeholder methods for parsing other data types; implement similarly to _parseExpenses
  List<CreditCard> _parseCreditCards(Map<dynamic, dynamic>? rawData) {
    if (rawData == null) return [];
    print(rawData.toString());
    return rawData.entries.map((e) {
      // Assuming e.value is a Map<String, dynamic> that can be passed directly to Expense.fromJson
      // And assuming that Expense.fromJson expects a Map<String, dynamic>
      print(e.key);
      print(e.value);
      return CreditCard.fromJson(e.key, Map<String, dynamic>.from(e.value));
    }).toList();
  }

/*
  List<CreditCard> _parseCreditCards(Map<dynamic, dynamic>? rawData) => [];
*/
/*
  List<SavingsAcc> _parseSavingsAcc(Map<dynamic, dynamic>? rawData) => [];
*/
/*  List<DepositsAcc> _parseDepositsAcc(Map<dynamic, dynamic>? rawData) => [];*/
  List<Category> _parseCategories(Map<dynamic, dynamic>? rawData) => [];

}
