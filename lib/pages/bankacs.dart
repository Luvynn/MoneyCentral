import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/savings/savings_tile.dart';
import 'package:awesomeapp/widgets/deposits/deposits_tile.dart';
import 'package:awesomeapp/models/savingsAcc.dart';
import 'package:awesomeapp/models/depositsAcc.dart';

class BankAcsPage extends StatefulWidget {
  @override
  _BankAcsPageState createState() => _BankAcsPageState();
}

class _BankAcsPageState extends State<BankAcsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "monthlyTarget": null,
    "yearlyTarget": null,
  };

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        var savingsAcc = model.ccAllSavingsAcc;
        var depositAccs = model.ccAllDepositsAcc;

        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: isLightTheme ? Colors.green[300] : Colors.grey[900],
                  pinned: false,
                  floating: false,
                  expandedHeight: 100.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: topArea(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return SavingsTile(
                          savingsAcc[index],
                          index,
                          model?.userCurrency?? '',
                          model.deleteSavingsAcc
                      );
                    },
                    childCount: savingsAcc.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return DepositssTile(
                          depositAccs[index],
                          index,
                          model?.userCurrency?? '',
                          model.deleteDepositsAcc
                      );
                    },
                    childCount: depositAccs.length,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Handle the action for adding new Savings/Deposit
            },
            backgroundColor: Theme.of(context).primaryColorLight,
            icon: const Icon(Icons.add),
            label: const Text('Add Savings/Deposit'),
          ),
        );
      },
    );
  }

  Card topArea() => Card(
    margin: EdgeInsets.all(10.0),
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50.0))),
    child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [Color(0xFF015FFF), Color(0xFF015FFF)])
        ),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Handle back action
                  },
                ),
                Text("Bank Accounts", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    // Handle forward action
                  },
                )
              ],
            ),
          ],
        )
    ),
  );
}
