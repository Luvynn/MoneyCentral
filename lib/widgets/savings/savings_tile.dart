import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesomeapp/pages/add_expense.dart';
import 'package:awesomeapp/models/savingsAcc.dart';
import 'package:awesomeapp/main.dart';

class SavingsTile extends StatelessWidget {
  final SavingsAcc savingsAcc;
  final int index;
  final String currency;
  final Function deleteSavingsAcc;
  SavingsTile(this.savingsAcc, this.index, this.currency,
      this.deleteSavingsAcc);

  _buildModelSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.deepOrangeAccent[100]
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              "Savings Account - " + savingsAcc.accno,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text("Deposits   - " +
              currency +
                  (double.parse(savingsAcc.deposits) / 100).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text("Withdrawls - " +
              currency +
                  (double.parse(savingsAcc.withdrawls) / 100).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text("Balance    - " +
                currency +
                (double.parse(savingsAcc.deposits) - (double.parse(savingsAcc.withdrawls)) / 100).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      onDismissed: (direction) {
        deleteSavingsAcc(savingsAcc.key);
      },
      direction: DismissDirection.endToStart,
      dismissThresholds: {DismissDirection.endToStart: 0.6},
      background: Container(
        color: deviceTheme == "light" ? Colors.red : Colors.red[700],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddExpense(),
                      ),
                    );
                  },
                  backgroundColor: Theme.of(context).primaryColorLight,
                  elevation: 5.0,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Savings Acc'),
                )
              ],
            )
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        bool shouldDelete = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Are you sure you want to delete this entry?"),
              title: Text("Delete"),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    shouldDelete = true;
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    shouldDelete = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );

        if (shouldDelete) {
          return true;
        } else {
          return false;
        }
      },
      key: Key(savingsAcc.key),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                savingsAcc.bankName + " - Savings A/C No ",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              Text(
                savingsAcc.accno,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(bottom: 1.0),
                elevation: 0.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildModelSheet(context);
                        });
                  },
                  splashColor: Colors.blue[100],
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5722),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    height: 90.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF5722),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Deposits",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                                ),
                              ),
                              Text(
                                currency +
                                    (double.parse(savingsAcc.deposits) / 100).toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Withdrawls",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                currency +
                                    (double.parse(savingsAcc.withdrawls) / 100).toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Balance",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                currency +
                                    (double.parse(savingsAcc.deposits) - (double.parse(savingsAcc.withdrawls)) / 100).toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
