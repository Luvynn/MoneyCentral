import 'package:awesomeapp/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesomeapp/pages/module_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userName = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget getWelcomeScreen(MainModel model) {
    return model?.authenticatedUser?.displayName != null
        ? ModulesPage()
        : GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: deviceTheme == "light"
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey[900],
              pinned: false,
              floating: false,
              expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: SafeArea(
                    bottom: false,
                    top: true,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Wrap(
                              children: <Widget>[
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "to",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "Money Central",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
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
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 400,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                SizedBox(
                                  width: 50,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Card(
                                      elevation: 10.0,
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/filters.jpg",
                                            color: Colors.black,
                                            colorBlendMode:
                                            BlendMode.dstATop,
                                            height: 350,
                                            width: 200,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Filter your expenses")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Card(
                                      elevation: 10.0,
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/edit.jpg",
                                            color: Colors.black,
                                            colorBlendMode:
                                            BlendMode.dstATop,
                                            height: 350,
                                            width: 200,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "View and edit your expenses")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Card(
                                      elevation: 10.0,
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/delete.jpg",
                                            color: Colors.black,
                                            colorBlendMode:
                                            BlendMode.dstATop,
                                            height: 350,
                                            width: 200,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Swipe to delete")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                          Card(
                            clipBehavior: Clip.none,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextFormField(
                              validator: (String? value) {
                                if (value?.length == 0) {
                                  return "Please enter a display name";
                                }
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  userName = value ?? '';
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                  vertical: 15.0,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                  BorderRadius.circular(30.0),
                                ),
                                hintText: "Display Name",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                filled: true,
                                fillColor: deviceTheme == "light"
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, _, model) {
        return getWelcomeScreen(model);
      },
    );
  }
}
