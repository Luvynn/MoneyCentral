import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesomeapp/models/ccExpense.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/cc/ccexpense_list.dart';
import 'package:awesomeapp/models/category.dart';

class CCExpensesList extends StatefulWidget {
  @override
  _CCExpensesListState createState() => _CCExpensesListState();
}

class _CCExpensesListState extends State<CCExpensesList> {
  late Future<void> _dataFuture;

  @override
  void initState() {
    super.initState();
    MainModel model = ScopedModel.of<MainModel>(context, rebuildOnChange: false);
    _dataFuture = _loadData(model);
  }

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
      print('start setting CC Expenses');
      data.forEach((key, value) {
        if (key == "ccExpenses" && value is Map) {
          value.forEach((key, value) {
            ccexpenses.add(CCExpense.fromJson(key,value));
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        return FutureBuilder<void>(
          future: _dataFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error loading data: ${snapshot.error}"));
            }
            return CCExpenseList(); // Assuming CCExpenseList() is set up to use the updated model data
          },
        );
      },
    );
  }
}
