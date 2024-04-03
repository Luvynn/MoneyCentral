import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';

class IdeasPage extends StatefulWidget {
  @override
  _IdeasState createState() => _IdeasState();
}

class _IdeasState extends State<IdeasPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine if the theme is light or dark.
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme ? Colors.green[100] : Colors.grey[800],
      appBar: AppBar(
        title: Text('Ideas for Future Features'),
        backgroundColor: isLightTheme ? Colors.green[300] : Colors.grey[900],
      ),
      body: _buildIdeasList(),
      bottomNavigationBar: _buildBottomNavigationBar(isLightTheme, context),
    );
  }

  Widget _buildIdeasList() {
    // Sample ideas for demonstration.
    List<String> ideas = [
      "Add timeline of expenditures",
      "Link bank accounts",
      "Download credit card statements",
      "Add eWallet handling",
      "Share savings details with family",
      "Scan receipts to add expenses",
      "Add photos of key deposits/expenses",
      "Add more widgets on dashboard",
      "Implement tax calculations",
      "Update investment market rates daily",
      "Scan and validate credit cards",
      "More periodic statistics",
    ];

    return ListView.builder(
      itemCount: ideas.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(ideas[index]),
            leading: Icon(Icons.lightbulb_outline),
          ),
        );
      },
    );
  }

  BottomAppBar _buildBottomNavigationBar(bool isLightTheme, BuildContext context) {
    return BottomAppBar(
      color: isLightTheme ? Colors.white : Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              MdiIcons.home,
              color: _selectedIndex == 0 ? Theme.of(context).colorScheme.secondary : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 0),
          ),
          IconButton(
            icon: Icon(
              MdiIcons.lightbulbOnOutline,
              color: _selectedIndex == 1 ? Theme.of(context).colorScheme.secondary : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 1),
          ),
        ],
      ),
    );
  }
}
