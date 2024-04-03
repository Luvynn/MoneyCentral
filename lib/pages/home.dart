import 'package:awesomeapp/widgets/expenses/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/navigation/side_drawer.dart';
import 'package:awesomeapp/pages/expenses_builder.dart';
import 'package:awesomeapp/pages/cc_builder.dart';
import 'package:awesomeapp/pages/ccexpense_overview.dart';
import 'package:awesomeapp/pages/add_expense.dart';
import 'package:awesomeapp/pages/add_ccexpense.dart';
import 'package:awesomeapp/pages/settings.dart';
import 'package:awesomeapp/pages/module_main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      ModulesPage(),
      ExpenseList(),
      CCExpensesList(),
      SettingsPage(),
    ];
  }

  Widget _buildDrawer(MainModel model) {
    return SideDrawer(model.updateCategoryFilter, model.updateSort, model.sortBy, model.allCategories, model.startDate!, model.endDate!);
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isLightTheme ? Colors.grey[100] : Theme.of(context).primaryColorDark,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddExpense())),
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      )
          : null,
      drawer: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? child, MainModel model) {
          return _buildDrawer(model);
        },
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        color: isLightTheme ? Colors.white : Colors.grey[850],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.viewDashboard, color: _selectedIndex == 0 ? Theme.of(context).colorScheme.secondary : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 0),
            ),
            IconButton(
              icon: Icon(MdiIcons.wallet, color: _selectedIndex == 1 ? Theme.of(context).colorScheme.secondary : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
            IconButton(
              icon: Icon(MdiIcons.creditCard, color: _selectedIndex == 2 ? Theme.of(context).colorScheme.secondary : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 2),
            ),
            IconButton(
              icon: Icon(MdiIcons.settingsHelper, color: _selectedIndex == 3 ? Theme.of(context).colorScheme.secondary : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}
