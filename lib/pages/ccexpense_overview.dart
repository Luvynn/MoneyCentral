import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/widgets/categories/category_summary.dart';
import 'package:awesomeapp/utils/data_cruncher.dart';

class CCExpenseOverview extends StatefulWidget {
  @override
  _CCExpenseOverviewState createState() => _CCExpenseOverviewState();
}

class _CCExpenseOverviewState extends State<CCExpenseOverview> {
  final dataCruncher = DataCruncher();
  String timeSummary = "week";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        var topCategories = dataCruncher.getBreakdownByCard(
            model.ccAllCreditCards, model.ccAllExpenses, model.userCurrency?? '');

        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: isLightTheme
                        ? theme.colorScheme.secondary
                        : Colors.grey[900],
                    expandedHeight: 240,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildAppBarContent(model),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      child: Container(
                        color: isLightTheme ? theme.colorScheme.secondary : Colors.grey[900],
                        alignment: Alignment.center,
                        child: Text(
                          'Breakdown by Card',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return CategorySummary(topCategories[index].name,
                            topCategories[index].total, model?.userCurrency?? '');
                      },
                      childCount: topCategories.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBarContent(MainModel model) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        children: <Widget>[
          Text(
            "Card Expense Overview",
            style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 20),
          // Other widgets...
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child is PreferredSizeWidget ? (child as PreferredSizeWidget).preferredSize.height : 56.0;

  @override
  double get minExtent => child is PreferredSizeWidget ? (child as PreferredSizeWidget).preferredSize.height : 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
