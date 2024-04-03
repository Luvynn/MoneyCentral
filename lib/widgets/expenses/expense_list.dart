import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesomeapp/models/expense.dart';
import 'package:awesomeapp/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/expenses/expense_tile.dart';
import 'package:awesomeapp/main.dart';
import 'package:awesomeapp/pages/expense_overview.dart';
import 'package:awesomeapp/pages/add_expense.dart';
import 'dart:core';

class ExpenseList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExpenseListState();
  }
}

class _ExpenseListState extends State<ExpenseList> {
  TextEditingController controller = TextEditingController();
  late Future<void> _dataFuture;

  Future<void> _getData(User user, Function setExpenses, DateTime? lastUpdate,
      BuildContext context, Function gotNoData) async {
    Duration difference = DateTime.now().difference(lastUpdate!);
    print('difference in minutes');
    print(difference.inMinutes);
    if (difference.inMinutes < 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor:
        deviceTheme == "light" ? Colors.blueAccent : Colors.blue[800],
        content: Text(
            "Next update available in ${10 - difference.inMinutes} minutes."),
        action: SnackBarAction(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          label: "Dismiss",
          textColor: Colors.white,
        ),
      ));
    } else {
      DatabaseEvent event = await FirebaseDatabase.instance
          .reference()
          .child('users/${user.uid}/expenses')
          .once();
      DataSnapshot snapshot = event.snapshot;

      List<Expense> expenses = [];
      // Ensure snapshot.value is a Map before proceeding.
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> expenseMap = Map<dynamic, dynamic>.from(
            snapshot.value as Map);
        expenseMap.forEach((key, value) {
          // Ensure each value is a Map before trying to create an Expense from it.
          if (value is Map<dynamic, dynamic>) {
            expenses.add(
                Expense.fromJson(key, Map<String, dynamic>.from(value)));
          }
        });

        setExpenses(expenses);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor:
          deviceTheme == "light" ? Colors.blueAccent : Colors.blue[800],
          content: Text("Next update available in 10 minutes."),
          action: SnackBarAction(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            label: "Dismiss",
            textColor: Colors.white,
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        List<Expense> expenses = model.allExpenses  ;
        double total = 0;
        expenses.forEach((expense) {
          double price = double.parse(expense.amount) / 100;
          print("Amount is " + price.toString());
          total = total + price;
        });
        return Scaffold(
            body: GestureDetector(
              onTap: () {
                if (controller.text == null) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: deviceTheme == "light"
                        ? Theme
                        .of(context)
                        .colorScheme
                        .secondary
                        : Colors.grey[900],
                    automaticallyImplyLeading: false,
                    pinned: false,
                    floating: false,
                    expandedHeight: 260.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: Column(
                          children: <Widget>[
                            Card(
                              clipBehavior: Clip.none,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: TextField(
                                controller: controller,
                                onChanged: (String value) {
                                  model.updateSearchQuery(value);
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  filled: true,
                                  fillColor: deviceTheme == "light"
                                      ? Colors.white
                                      : Colors.grey[600],
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        controller.text = "";
                                      });
                                      model.updateSearchQuery("");
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              children: <Widget>[
                                Text(
                                  expenses.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "expenses totalling",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "${model.userCurrency}${model.userCurrency ==
                                      "€" ? total.toStringAsFixed(2).replaceAll(
                                      ".", ",") : total.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Currently sorting by ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  "${model.sortBy}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    if (model.allExpenses.length > 0) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ExpenseOverview(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: deviceTheme ==
                                              "light"
                                              ? Colors.blueAccent
                                              : Colors.blue[800],
                                          content: Text("No expenses found."),
                                          action: SnackBarAction(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                            },
                                            label: "Dismiss",
                                            textColor: Colors.white,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.pie_chart,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        "Overview",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () =>
                                      _getData(
                                          model.authenticatedUser!,
                                          model.setExpenses,
                                          model.lastUpdate,
                                          context,
                                          model.gotNoData),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        "Refresh",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return ExpenseTile(
                            expenses[index],
                            index,
                            model.expenseCategory,
                            model.userCurrency ?? '',
                            model.deleteExpense);
                      },
                      childCount: expenses.length,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerDocked,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddExpense(),
                  ),
                );
              },
              backgroundColor: Theme
                  .of(context)
                  .primaryColorLight,
              elevation: 5.0,
              icon: const Icon(Icons.add),
              label: const Text('Add Expense'),
            )
        );
      },
    );
  }

}
