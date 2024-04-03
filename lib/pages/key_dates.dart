import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/pages/module_main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class KeyDatesPage extends StatefulWidget {
  @override
  _KeyDatesState createState() => _KeyDatesState();
}

class _KeyDatesState extends State<KeyDatesPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine if the theme is light or dark
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? Colors.green[100] : Colors.grey[800],
      appBar: AppBar(
        title: Text('Key Payment Dates'),
        backgroundColor: isLightTheme ? Colors.green[300] : Colors.grey[900],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        color: isLightTheme ? Colors.white : Colors.grey[900],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.home, color: _selectedIndex == 0 ? Theme.of(context).colorScheme.secondary : Colors.grey[500]),
              onPressed: () => setState(() => _selectedIndex = 0),
            ),
            IconButton(
              icon: Icon(MdiIcons.calendar, color: _selectedIndex == 1 ? Theme.of(context).colorScheme.secondary : Colors.grey[500]),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          pinned: false,
          floating: false,
          expandedHeight: 180.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Color(0xFFf0f4c3),
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Column(
                children: <Widget>[
                  Card(
                    child: Text(
                      "Key Payment Dates",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    color: Color(0xFF9ccc65),
                  ),
                  Card(
                    child: Text(
                      "Total Due this month \$3023.00",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    color: Color(0xFFc5e1a5),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _upcomingPaymentsHeader(),
              _paymentCard("House Loan Installment", 1023.00, 1),
              _paymentCard("Mobile Bill", 78.00, 4),
              _paymentCard("Internet/Cable Bill", 102.00, 5),
              _paymentCard("Netflix Subscription", 15.00, 12),
              // Add more KeyDateCard widgets as needed
            ],
          ),
        ),
      ],
    );
  }

  Widget _upcomingPaymentsHeader() {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      color: isLightTheme ? Colors.white : Colors.grey[800],
      child: ListTile(
        title: Text("Upcoming Payments", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _paymentCard(String title, double amount, int daysFromNow) {
    DateTime dueDate = DateTime.now().add(Duration(days: daysFromNow));
    String formattedDate = DateFormat('E dd MMM').format(dueDate);

    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(MdiIcons.calendarCheck, color: Colors.teal),
        title: Text(title),
        subtitle: Text("Due on $formattedDate"),
        trailing: Text("\$$amount",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
}