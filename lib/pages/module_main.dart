import 'package:awesomeapp/main.dart';
import 'package:awesomeapp/pages/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesomeapp/pages/expenses_builder.dart';
import 'package:awesomeapp/pages/cc_builder.dart';
import 'package:awesomeapp/pages/settings.dart';
import 'package:awesomeapp/pages/key_dates.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:awesomeapp/pages/savings.dart';
import 'package:awesomeapp/pages/bankacs.dart';
import 'package:awesomeapp/pages/summary.dart';
import 'package:awesomeapp/pages/ideas.dart';
import 'package:awesomeapp/models/expense.dart';
import 'package:awesomeapp/models/ccExpense.dart';
import 'package:awesomeapp/models/user.dart';
import 'package:awesomeapp/pages/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';


class ModulesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ModulesPageState();
  }
}

class _ModulesPageState extends State<ModulesPage> {
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  String _nameFormData= '';
  int _selectedIndex = 0;
  final _widgetOptions = [
    ModulesPage(),
    ExpensesList(),
    CCExpensesList(),
  ];

  Future<void> _getData(User user, Function setExpenses, DateTime lastUpdate,
      BuildContext context, Function gotNoData) async {
    Duration difference = DateTime.now().difference(lastUpdate);
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
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> expenseMap = snapshot.value as Map<dynamic, dynamic>;
        expenseMap.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            expenses.add(Expense.fromJson(user.uid, Map<String, dynamic>.from(value)));
          }
        });
      }
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


  @override
  void initState() {
    super.initState();
    _nameFormData = "";
    deviceTheme == "light" ? true : false;
  }
  void _onExpensesButtonPressed() {
    print("Expenses button clicked");
    setState(() {
      _selectedIndex = 1;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExpensesList(),
        ),
      );
    });
  }

  void _onCcButtonPressed() {
    print("CC Expenses button clicked");
    setState(() {
      _selectedIndex = 1;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CCExpensesList(),
      ),
    );
  }

  void _onSavingsButtonPressed() {
    print("Savings button clicked");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SavingsPage(),
      ),
    );
  }

  void _onSummaryButtonPressed() {
    print("Summary button clicked");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SummaryPage(),
      ),
    );
  }

  void _onBankAcsButtonPressed() {
    print("Bank Acs button clicked");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BankAcsPage(),
      ),
    );
  }


  void _onSettingsPressed() {
    print("Settings button clicked");
    setState(() {
      _selectedIndex = 1;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ),
    );
  }


  void _onKeyDateButtonPressed() {
    print("Key Dates button clicked");
    setState(() {
      _selectedIndex = 1;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => KeyDatesPage(),
      ),
    );
  }

  void _onIdeasButtonPressed() {
    print("Ideas button clicked");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IdeasPage(),
      ),
    );
  }

  void _onWelcomeButtonPressed() {
    print("Welcome button clicked");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MySplashScreen(),
      ),
    );
  }


  final body1Style = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 26.0,
    color: Colors.black,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deviceTheme == "light1"
          ? Colors.yellowAccent[50]
          : Theme
          .of(context)
          .primaryColorLight,
      body: _buildBody(),
    );
  }

  _buildBody(){
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        List<Expense> expenses = model.allExpenses;
        List<CCExpense> ccexpenses = model.ccAllExpenses;
        print("Get total expenses");
        print(expenses.toString());
        print(ccexpenses.toString());
        String monthlyTarget = '1000';
        double total = 0;
        expenses.forEach((expense) {
          print(expense.amount);
          double price = double.parse(expense.amount) / 100;
          total = total + price;
        });
        print("Total " + total.toString());
        ccexpenses.forEach((ccexpense) {
          double price = double.parse(ccexpense.amount) / 100;
          total = total + price;
        });
        double percentValue =  total / (total + double.parse(monthlyTarget.replaceAll(",", "")))  * 100 ;
        print('Percent Value');
        print(percentValue);
        return GestureDetector(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: deviceTheme == "light"
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey[900],
                pinned: false,
                floating: false,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/MoneyCentralLogo.jpg"),
                        fit: BoxFit.fill,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 120),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      MdiIcons.settingsHelper,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: _onSettingsPressed,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.0),
                      color: deviceTheme == "light"
                          ? Colors.white
                          : Colors.grey[800],
                      child: ListTile(
                        title: Text("Current Month Expenditure: ${model.userCurrency} " + total.toStringAsFixed(2), textScaleFactor: 1.1,),
                        trailing: IconButton(
                          iconSize: 30.0,
                          onPressed: _onSummaryButtonPressed,
                          icon: Icon(MdiIcons.target,
                            color: Colors.red,),
                        ),
                      ),
                    ),
                    new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width ,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: percentValue /100,
                      center: Text(percentValue.toStringAsFixed(2) + "%"),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.cyanAccent,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        ModuleCard(icon: Icons.assignment,
                          iconColour: Colors.deepOrange,
                          buttonText: "Summary",
                          onPressed: _onSummaryButtonPressed,
                        ),
                        ModuleCard(icon: Icons.business_center,
                          iconColour: Colors.blue,
                          buttonText: "Savings",
                          onPressed: _onSavingsButtonPressed,
                        ),
                        ModuleCard(icon: Icons.shopping_cart,
                          iconColour: Colors.indigo,
                          buttonText: "Expenses",
                          onPressed: _onExpensesButtonPressed,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        ModuleCard(icon: Icons.credit_card,
                          iconColour: Colors.pink,
                          buttonText: "Credit Card",
                          onPressed: _onCcButtonPressed,
                        ),
                        ModuleCard(icon: Icons.account_balance,
                          iconColour: Colors.brown,
                          buttonText: "Bank A/c",
                          onPressed: _onBankAcsButtonPressed,
                        ),
                        ModuleCard(icon: Icons.date_range,
                          iconColour: Colors.teal,
                          buttonText: "Key Dates",
                          onPressed: _onKeyDateButtonPressed,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        ModuleCard(icon: Icons.card_membership,
                          iconColour: Colors.cyan,
                          buttonText: "Taxes",
                          onPressed: _onWelcomeButtonPressed,
                        ),
                        ModuleCard(icon: Icons.attach_money,
                          iconColour: Colors.deepPurpleAccent,
                          buttonText: "Investments",
                          onPressed: _onWelcomeButtonPressed,
                        ),
                        ModuleCard(icon: Icons.wb_incandescent,
                          iconColour: Colors.yellowAccent,
                          buttonText: "Ideas",
                          onPressed: _onIdeasButtonPressed,
                        ),
                      ],
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

class ModuleCard extends StatelessWidget {

  ModuleCard({required this.icon, required this.iconColour,required this.buttonText,required this.onPressed });
  IconData icon;
  Color iconColour;
  String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 5.0,
          child: SizedBox(
            height: 140.0,
            width: 120.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: IconButton(icon: Icon(icon, color: iconColour, ),
                        iconSize: 80.0,
                        onPressed: onPressed
                    )
                ),
                Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  right: 16.0,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                        buttonText,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 26.0,
                          color: Colors.white,
                        )
                    ),
                  ),
                )
              ],
            ),
          ),
          color: Colors.lightBlueAccent[50],
        ),
      ),
    );
  }
}
