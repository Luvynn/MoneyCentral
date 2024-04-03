import 'package:awesomeapp/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesomeapp/pages/module_main.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class SavingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SavingsPageState();
  }
}

class _SavingsPageState extends State<SavingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "monthlyTarget": null,
    "yearlyTarget": null,
  };

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

  _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: deviceTheme == "light"
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[900],
      ),
      child: MaterialButton(
          onPressed: () async {
            // Ensure the form is valid before proceeding
            if (_formKey.currentState?.validate() ?? false) {
              print("Save state is valid");
              _formKey.currentState?.save();
            }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCancelButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: deviceTheme == "light"
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[900],
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTargetField(String label, String targetName) {
    return Card(
      clipBehavior: Clip.none,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a target";
          }
          return null; // Indicate that the input is valid
        },
        onSaved: (String? value) => _formData[targetName] = value,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 2.0,
            vertical: 2.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
          hintText: label,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefix: Text("  "),
          filled: true,
          fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  _buildForm(model) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
             // _buildTitleField(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSaveButton(),
                  SizedBox(
                    width: 10,
                  ),
                  _buildCancelButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  _buildFormContainer(Model model) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: deviceTheme == "light"
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey[900],
          expandedHeight: 80,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: SafeArea(
                bottom: false,
                top: true,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Manage",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Targets",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              _buildForm(model),
            ],
          ),
        ),
      ],
    );
  }

  static const PrimaryColor =  Color(0xFFC8E6C9);

  Card topArea(String outstandingBal) => Card(
    margin: EdgeInsets.all(10.0),
    elevation: 2.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0))),
    child: Container(
        padding: EdgeInsets.all(5.0),
        color: Colors.black,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                Text("Total Savings",
                    style: TextStyle(color: Colors.green[400], fontSize: 28.0)),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(outstandingBal,
                    style: TextStyle(color: Colors.white, fontSize: 24.0)),
              ),
            ),
            SizedBox(height: 0),
          ],
        )),
  );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        String monthlyTarget = model.userMonthlyTarget?? '';
        String yearlyTarget = model.userYearlyTarget?? '';

        return Scaffold(
          body: GestureDetector(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  pinned: false,
                  floating: false,
                  expandedHeight: 90.0,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlexibleSpaceBar(
                      background: topArea(model.userOutstandingAccBal ?? '')
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(1),
                          child: Container(
                            padding: EdgeInsets.only(left: 7),
                            child: Text(
                              "Savings Targets",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.lime[100],
                              ),
                            ),
                          ),
                        ),
                        color: Colors.blueGrey[700]
                      ),
                      Row(
                        children: <Widget>[
                          MessageCard(mainText: "For the Month",
                            currency: "\$",
                            amount: monthlyTarget,
                          ),
                          MessageCard(mainText: "For the Year",
                            currency: "\$",
                            amount: yearlyTarget,
                          ),
                        ],
                      ),
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 2.0),
                          child: Container(
                            padding: EdgeInsets.all(1),
                            child: Container(
                              padding: EdgeInsets.only(left: 7),
                              child: Text(
                                "Savings",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.lime[100],
                                ),
                              ),
                            ),
                          ),
                          color: Colors.blueGrey[700]
                      ),
                      Row(
                        children: <Widget>[
                          MessageCard(mainText: "Current Month",
                            currency: "\$",
                            amount: "2,340",
                          ),
                          MessageCard(mainText: "Current Year",
                            currency: "\$",
                            amount: "24,320",
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          PercentageCard(
                            percent: 0.5425,
                          ),
                          PercentageCard(
                            percent: 0.64,
                          ),
                        ],
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              "Manage Targets",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.lime[100],
                              ),
                            ),
                          ),
                        ),
                        color: Colors.blueGrey[700]
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Set New Target"),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        _buildTargetField("New Monthly Taget","monthlyTarget"),
                                        _buildTargetField("New Yearly Target", "yearlyTarget"),
                                      ],
                                    )
                                )
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
                          _buildSaveButton(),
                          _buildCancelButton(),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
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

  const MessageCard({
    Key? key,
    required this.mainText,
    required this.currency,
    required this.amount,
  }) : super(key: key);

  static const Color primaryColor = Color(0xFF009688);
  static const Color primaryAccentColor = Color(0xFF4a148c);
  static const Color primaryDarkColor = Color(0xFF880e4f);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [primaryDarkColor, primaryAccentColor, primaryColor],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              mainText,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: currency,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  TextSpan(
                    text: amount,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PercentageCard extends StatelessWidget {
  final double percent;

  const PercentageCard({
    Key? key,
    required this.percent, // Making percent required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          child: SizedBox(
            height: 260.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded (
                flex: 1,
                child: CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 15.0,
                  animation: true,
                  percent: percent,
                  center: Text(
                    "${(percent * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.greenAccent[700],
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.indigo,
                  backgroundColor: Colors.teal,
                ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
