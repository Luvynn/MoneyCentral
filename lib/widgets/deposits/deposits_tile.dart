import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesomeapp/pages/add_expense.dart';
import 'package:awesomeapp/models/depositsAcc.dart';
import 'package:awesomeapp/main.dart';

class DepositssTile extends StatelessWidget {
  final DepositsAcc depositsAcc;
  final int index;
  final String currency;
  final Function deleteSavingsAcc;
  DepositssTile(this.depositsAcc, this.index, this.currency,
      this.deleteSavingsAcc);

  _buildModelSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
             'Deposits Account :' + depositsAcc.accno,
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
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              'Principal Amount : ' + currency +
                  (double.parse(depositsAcc.principal) / 100).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.white,
                fontSize: 25
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              'Maturity Amount : ' + currency +
                  (double.parse(depositsAcc.maturity) / 100).toStringAsFixed(2),
              style: TextStyle(
                color: Colors.black,
                  fontSize: 25
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              'Rate : ' + (double.parse(depositsAcc.rate) / 100).toStringAsFixed(2) + '%',
              style: TextStyle(
                color: Colors.black,
                  fontSize: 25
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              'Term : ' + (double.parse(depositsAcc.term)).toStringAsFixed(2) + ' months',
              style: TextStyle(
                color: Colors.black,
                  fontSize: 25
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
        deleteSavingsAcc(depositsAcc.key);
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
      key: Key(depositsAcc.key),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                depositsAcc.bankName + " - Depoits A/C No ",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              Text(
                depositsAcc.accno,
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
                      color: Color(0xFF7C4DFF),
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
                            color: Color(0xFF7C4DFF),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Maturity",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white
                                ),
                              ),
                              Text(
                                currency +
                                    (double.parse(depositsAcc.maturity) / 100).toStringAsFixed(2),
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
                            color: Color(0xFFF44336),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Principal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                currency +
                                    (double.parse(depositsAcc.principal) / 100).toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.white,
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
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Term",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                    (double.parse(depositsAcc.term)).toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
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
