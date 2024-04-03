import 'package:awesomeapp/pages/home.dart';
import 'package:awesomeapp/pages/ideas.dart';
import 'package:awesomeapp/pages/module_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesomeapp/pages/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesomeapp/firebase_options.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String deviceTheme = "light";
bool? firstRun;

final FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyCp6Yso1tzE2f3Wh5-BimP_UQu2amV6CDM",
  appId: "364150503455-tsuotc6l3focogs0028jq5qe27bp8mmi.apps.googleusercontent.com",
  messagingSenderId: "364150503455",
  projectId: "moneycentral-42aa3",
  // Other options if needed
);


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue[700],
  primaryColorLight: Colors.blueAccent,
  canvasColor: Colors.blueAccent,
);

final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[700],
    primaryColorLight: Colors.grey[850],
    canvasColor: Colors.blue,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Color(0xffBA379B).withOpacity(.5),
      cursorColor: Color(0xffBA379B).withOpacity(.6),
      selectionHandleColor: Color(0xffBA379B).withOpacity(1),
  ),);

restartApp() {
  main();
}

logout() {
  if (deviceTheme == "light") {
    runApp(MyApp(lightTheme));
  } else {
    runApp(MyApp(darkTheme));
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  print('App Initializing');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('App Initialized');
  SharedPreferences pref = await SharedPreferences.getInstance();
  String theme = (pref.getString("theme") ?? "light");
  deviceTheme = theme;
    runApp(MyApp(darkTheme));
}

class MyApp extends StatefulWidget {
  final ThemeData theme;
  MyApp(this.theme, {super.key});
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MainModel model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: 'Money Central',
        home: _authenticateUser(model.loginUser, model),
        theme: widget.theme,
      ),
    );
  }
}

Widget _authenticateUser(Function loginUser, MainModel model) {
  return StreamBuilder<User?>(
    stream: _auth.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildSplashScreen();
      } else {
        if (snapshot.hasData) {
          dynamic user = _auth.currentUser;
          print("Current user is " + _auth.currentUser.toString());
          //Fetch User Data
          loginUser(user.displayName, user.uid, user.email, user);

          return HomePage();
        }
        return LoginScreen();
      }
    },
  );
}


Widget _buildSplashScreen() {
  return Scaffold(
    body: Center(
      child: Text("Loading..."),
    ),
  );
}
