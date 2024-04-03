import 'package:flutter/material.dart';


class MySplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MySplashScreeState();
  }
}

class _MySplashScreeState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AfterSplash();
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Welcome To Money Central"),
        automaticallyImplyLeading: false,
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            new Text("Stay Tuned.",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
              ),),
           new Icon(
              Icons.important_devices,
              color: Colors.blue,
             size: 200,
            ),
            new Text("Module Coming Soon!",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0
              ),),
          ],
        ),
      ),
    );
  }
}