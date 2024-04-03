import 'package:awesomeapp/models/category.dart';

class Preferences {
  String theme;
  String currency;
  String monthlyTarget;
  String yearlyTarget;
  String outstandingAccBal;
  String projectedSpending;

  List<Category> categories;

  Preferences(this.theme, this.currency, this.categories, this.monthlyTarget, this.yearlyTarget, this.projectedSpending, this.outstandingAccBal);

  set updateCategories(List<Category> newCategories) {
    categories = newCategories;
  }

  set updateTheme(String newTheme) {
    theme = newTheme;
  }

  set updateCurrency(String newCurrency) {
    currency = newCurrency;
  }

  set updateMonthlyTarget(String newMontlyTarget) {
    monthlyTarget = newMontlyTarget;
  }

  set updateYearlyTarget(String newYearlyTarget) {
    yearlyTarget = newYearlyTarget;
  }

  set updateProjectedSpending(String projectedSpending) {
    projectedSpending = projectedSpending;
  }

  set updateOutstandingAccBal(String outstandingAccBal) {
    outstandingAccBal = outstandingAccBal;
  }

}
