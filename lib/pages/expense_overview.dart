import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/categories/category_summary.dart';
import 'package:awesomeapp/utils/data_cruncher.dart';
import 'package:awesomeapp/pages/add_expense.dart';

class ExpenseOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExpenseOverviewState();
}

class _ExpenseOverviewState extends State<ExpenseOverview> {
  final dataCruncher = DataCruncher();
  String timeSummary = "week";

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        var topCategories = dataCruncher.getTopCategories(
            model.allCategories, model.allExpenses, model.userCurrency?? '');

        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: isDarkTheme ? Colors.grey[900] : Theme.of(context).colorScheme.secondary,
                  expandedHeight: 240,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildAppBarContent(model, isDarkTheme),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: Container(
                        color: isDarkTheme ? Colors.grey[850] : Theme.of(context).colorScheme.secondary,
                        alignment: Alignment.center,
                        child: Text(
                          'Breakdown by Category',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CategorySummary(
                          topCategories[index].name, topCategories[index].total, model.userCurrency?? '');
                    },
                    childCount: topCategories.length,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddExpense(),
                ),
              );
            },
            icon: Icon(Icons.add),
            label: Text('Add Expense'),
            backgroundColor: isDarkTheme ? Colors.grey[700] : Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildAppBarContent(MainModel model, bool isDarkTheme) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        children: <Widget>[
          Text(
            "Expense Overview",
            style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20),
          Text(
            "Total Expenses: ${model.userCurrency}${dataCruncher.getTotal(model.allExpenses).toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                timeSummary = timeSummary == "month" ? "week" : "month";
              });
            },
            child: Text(
              "Total This ${timeSummary == "month" ? "Month" : "Week"}: ${model.userCurrency}${timeSummary == "month" ? dataCruncher.getMonthTotal(model.allExpenses).toStringAsFixed(2) : dataCruncher.getWeekTotal(model.allExpenses).toStringAsFixed(2)}",
              style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
