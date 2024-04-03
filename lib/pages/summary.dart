  import 'package:awesomeapp/main.dart';
import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:scoped_model/scoped_model.dart';
  import 'package:awesomeapp/scoped_models/main.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
  import 'package:awesomeapp/pages/module_main.dart';
  import 'package:percent_indicator/circular_percent_indicator.dart';
  import 'package:awesomeapp/widgets/charts/NumericComboLinePointChart.dart';
  import 'package:awesomeapp/models/ccExpense.dart';
  import 'package:awesomeapp/models/expense.dart';



  class SummaryPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
      return _SummaryPageState();
    }

  }

  class _SummaryPageState extends State<SummaryPage> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    @override
    void initState() {
      super.initState();
    }

    void _onHomePressed() {
      print("Home button clicked");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ModulesPage(),
        ),
      );
    }

    static const PrimaryColor =  Color(0xFFC8E6C9);

    @override
    Widget build(BuildContext context) {
      List<Color> gradientColors = [
        Color(0xff23b6e6),
        Color(0xff02d39a),
      ];
      return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? widget, MainModel model) {
          String monthlyTarget = '';
          if (model.userMonthlyTarget != null) {
            monthlyTarget = model.userMonthlyTarget!;
          }
          String yearlyTarget = '';
          if (model.userYearlyTarget != null) {
            yearlyTarget = model.userYearlyTarget!;
          }
          List<CCExpense> ccexpenses = model.ccAllExpenses;
          double cctotal = 0;
          ccexpenses.forEach((expense) {
            double price = double.parse(expense.amount) / 100;
            cctotal = cctotal + price;
          });
          String creditCardOutstanding = cctotal.toStringAsFixed(2);

          List<Expense> expenses = model.allExpenses;
          double total = 0;
          expenses.forEach((expense) {
            double price = double.parse(expense.amount) / 100;
            total = total + price;
          });
          String monthlyExpenses = total.toStringAsFixed(2);


          return Scaffold(
            appBar: AppBar(
              title: Text('Summary'),
              centerTitle: true,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: MessageCard(mainText: "Expenses for the Month",
                              currency: "\$",
                              amount: monthlyExpenses,
                              cardColor: Colors.redAccent
                            )
                          ),
                          Expanded(
                            child: MessageCard(mainText: "Credit Card Outstanding",
                                currency: "\$",
                                amount: creditCardOutstanding,
                                cardColor: Colors.purple
                              ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MessageCard(mainText: "Projected Average Spending",
                            currency: "\$",
                            amount: model.userProjectedSpending?? '0',
                            cardColor: Colors.green
                            )
                          ),
                          Expanded(
                            child: MessageCard(mainText: "Outstanding Account Balance",
                            currency: "\$",
                            amount: model.userOutstandingAccBal?? '0',
                            cardColor: Colors.teal
                            )
                          ),
                        ],
                      ),
/*
                      Row(
                        children: <Widget>[
                          PercentageCard(
                            percent: 0.66,
                          ),
                          PercentageCard(
                            percent: 0.52,
                          ),
                        ],
                      ),
*/
                      Text("Savings Vs Expenses",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontSize: 20),),
                      Container(
                        child: NumericComboLinePointChart.withSampleData(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  class MessageCard extends StatelessWidget {

    final String mainText;
    final String currency;
    final String amount;
    final Color cardColor;

    const MessageCard({
      Key? key,
      required this.mainText,
      required this.currency,
      required this.amount,
      required this.cardColor,
    }) : super(key: key);

    static const PrimaryColor =  Color(0xFF009688);
    static const PrimaryAssentColor =  Color(0xFF4a148c);
    static const PrimaryDarkColor =  Color(0xFF880e4f);

    @override
    Widget build(BuildContext context) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Card(
            elevation: 5.0,
            child: SizedBox(
              height: 125.0,
              width: 120.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            mainText,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(color: Colors.white, fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  currency,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  amount,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            color: Colors.white54,
          ),
        ),
      );
    }
  }


  class PercentageCard extends StatelessWidget {

    final double percent;

    const PercentageCard({Key? key, required this.percent}) : super(key: key);


    @override
    Widget build(BuildContext context) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Card(
            child: SizedBox(
              height: 180.0,
              width: 150.0,
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new CircularPercentIndicator(
                        radius: 130,
                        animation: true,
                        animationDuration: 4000,
                        progressColor: Colors.indigo,
                        percent: percent,
                        backgroundColor: Colors.teal,
                        center: new Text(
                          (percent * 100).toString() + "%",
                          style: TextStyle(
                            color: Colors.greenAccent[700],
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    )
                ],
              ),
            ),
            color: Colors.white,
          ),
        ),
      );
    }
  }

  class SalesData {
    SalesData(this.year, this.sales);
    final String year;
    final double sales;
  }
