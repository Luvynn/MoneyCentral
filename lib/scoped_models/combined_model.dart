import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/models/user.dart';
import 'package:awesomeapp/models/expense.dart';
import 'package:awesomeapp/models/ccExpense.dart';
import 'package:awesomeapp/models/savingsAcc.dart';
import 'package:awesomeapp/models/depositsAcc.dart';
import 'package:awesomeapp/models/preference.dart';
import 'package:awesomeapp/models/category.dart';
import 'package:awesomeapp/models/creditcard.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

final List<Category> defaultCategories = [
  Category("1", "Bills", icon: MdiIcons.fileDocument),
  Category("2", "Rent", icon: Icons.home),
  Category("3", "Food", icon: MdiIcons.foodForkDrink),
  Category("4", "Leisure", icon: MdiIcons.shopping),
  Category("5", "Debt", icon: Icons.monetization_on),
  Category("6", "Travel", icon: Icons.train),
  Category("7", "Miscellaneous", icon: MdiIcons.cashRegister),
];

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColorLight: Colors.white,
  canvasColor: Colors.blueAccent,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColorLight: Colors.grey,
);

mixin CombinedModel on Model {
  User? _authUser;
  List<Expense> _expenses = [];
  List<CCExpense> _ccExpenses = [];
  List<SavingsAcc> _savingsAcc =[];
  List<DepositsAcc> _depositsAcc =[];
  List<CreditCard> _creditCards=[];
  bool _synced = false;
  DateTime? _lastUpdated;
  String? _newName;
  Preferences? _userPreferences;
  String _sortBy = "date";
  String _searchQuery = "";
  DateTime? startDate;
  DateTime? endDate;

  bool get syncStatus {
    return _synced;
  }

  String? get newName {
    return _newName;
  }

  DateTime? get lastUpdate {
    return _lastUpdated;
  }

  void toggleSynced() {
    _synced = !_synced;
  }

  void gotNoData() {
    _expenses = [];
  }

  void loginUser(_displayName, _uid, _email, authUser) {
    if (_uid != null) {
      // Assuming displayName and photoURL can be null in Firebase User
      String displayName = _displayName ?? "No Name";
      //String photoUrl = _authUser?.photoURL ?? "default_photo_url";
      // email and uid are non-nullable in Firebase User
      String email = _email ?? '';
      String uid = _uid ?? '';
      _authUser = authUser;
    } else {
      // Handle the case where firebaseUser is null
      print("Firebase user is null");
    }
  }
}

mixin FilterModel on CombinedModel {
  Category expenseCategory(String categoryId) {
    var categories = _userPreferences?.categories ?? [];
    Category cat = categories.firstWhere(
        (category) => category.id == categoryId,
        orElse: () => Category("0", ""));
    return cat;
  }

  List<Category> get allCategories {
    var categories = _userPreferences?.categories ?? [];
    return categories;
  }

  void updateCategoryFilter(List<Category> newCategories) {
    if (_userPreferences == null) {
      // Initialize _userPreferences with some default values or state.
      _userPreferences = Preferences(
        'defaultTheme',
        'defaultCurrency',
        defaultCategories,
        '', '', '', ''
      );
    }

    _userPreferences?.categories = newCategories;
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value.toLowerCase();
    notifyListeners();
  }

  void updateSort(String value) {
    _sortBy = value;
    notifyListeners();
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  void updateCurrency(String currency) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/preferences/currency');
    String value = '';
    if (currency == "£") {
      value = "en-gb";
    } else if (currency == "\$") {
      value = "en";
    } else if (currency == "€") {
      value = "fr";
    }

    await ref.set(value);

    _userPreferences?.currency = currency;
    notifyListeners();
  }

  String get sortBy {
    return _sortBy;
  }

  String? get userTheme {
    return _userPreferences?.theme;
  }

  String? get userCurrency {
    if (_userPreferences != null) {
      return _userPreferences?.currency;
    } else {
      return 'SGD';
    }
  }

  String? get userMonthlyTarget {
    if (_userPreferences != null) {
      return _userPreferences?.monthlyTarget;
    } else {
      return null;
    }
  }

  String? get userYearlyTarget {
    return _userPreferences?.yearlyTarget;
  }

  String? get userProjectedSpending {
    if (_userPreferences != null) {
      return _userPreferences?.projectedSpending;
    } else {
      return null;
    }
  }

  String? get userOutstandingAccBal {
    if (_userPreferences != null) {
      return _userPreferences?.outstandingAccBal;
    } else {
      return null;
    }
  }


  void updateMonthlyTarget(String newMonthlyTarget) async{
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/preferences/monthlyTarget');
    await ref.set(newMonthlyTarget);
    _userPreferences?.monthlyTarget = newMonthlyTarget;
    notifyListeners();
  }

  void updateYearlyTarget(String newYearlyTarget) async{
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/preferences/yearlyTarget');
    await ref.set(newYearlyTarget);

    _userPreferences?.monthlyTarget = newYearlyTarget;
    notifyListeners();
  }

  String formatDate(DateTime date) {
    List<String> _date = date.toIso8601String().substring(0, 10).split("-");
    if (_userPreferences?.currency == '\$') {
      return "${_date[1]}-${_date[2]}-${_date[0]}";
    } else {
      return "${_date[2]}-${_date[1]}-${_date[0]}";
    }
  }

  void updateTheme(String theme) {
    _userPreferences?.theme = theme;
    notifyListeners();
  }

  void setPreferences(
      String theme, String currency, List<Category> categories,String monthlyTarget, String yearlyTarget, String projectedSpending, String outstandingAccBal) {
    String actualCurrency = "";
    if (currency == "en-gb") {
      actualCurrency = '£';
    } else if (currency == 'fr') {
      actualCurrency = '€';
    } else {
      actualCurrency = '\$';
    }

    List<Category> allCategories = List.from(defaultCategories)
      ..addAll(categories);
    _userPreferences = Preferences(theme, actualCurrency, allCategories, monthlyTarget, yearlyTarget, projectedSpending, outstandingAccBal);
  }
}

mixin ExpensesModel on CombinedModel {
  List<Expense> get allExpenses {
    print('return expenses');
    print(_expenses);
    return List.from(_expenses);
  }

  List<Expense> get filteredExpenses {
    List<Expense> output = [];
    print(_expenses);
    _expenses.forEach(
      (expense) {
        if (expense != null) {
          Category? category = _userPreferences?.categories.firstWhere(
              (category) => category.id == expense.category,
              orElse: () => Category("0", "empty"));
          if (category== null || category.name == "empty") {
            output.add(expense);
          }
        }
      },
    );

    List<Expense> rangeFilter = output;

    rangeFilter = output.where((expense) {
      int expenseDate = int.parse(expense.createdAt);
      int? _startDate = startDate?.millisecondsSinceEpoch;
      int? _endDate = endDate?.millisecondsSinceEpoch;

      return expenseDate >= _startDate! && expenseDate <= _endDate!;
    }).toList();
  
    List<Expense> finalOutput = rangeFilter.where((expense) {
      return expense.title.toLowerCase().contains(_searchQuery) ||
          expense.note.toLowerCase().contains(_searchQuery);
    }).toList();

    finalOutput.sort(
      (a, b) {
        if (_sortBy == "date") {
          return b.createdAt.compareTo(a.createdAt);
        } else if (_sortBy == "amount") {
          return double.parse(a.amount) < double.parse(b.amount) ? 1 : -1;
        } else if (_sortBy == "category") {
          return a.category.compareTo(b.category);
        } else {
          return 0;
        }
      },
    );

    return finalOutput;
  }


  void setExpenses(List<Expense> expenses) {
    _expenses = expenses;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }

  void backupExpenses() async {
    // Testing Backup Feature!
    List<String> jsonList = [];
    String jv = jsonEncode(_expenses);
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    File expenseBackup = File("${directory.path}/expenseBackup.json");
    expenseBackup.writeAsString(jv).catchError((error) {
      print(error);
    });

    // List<Expense> list = [];
    // print(jv);
    // List<dynamic> a = jsonDecode(jv);
    // a.forEach((val) {
    //   Map<String, dynamic>  help = {};
    //   val.forEach((key, value) {
    //     help[key] = value;
    //   });
    //   print(help);
    //   list.add(Expense.fromJson(help["key"], help));
    // });
  }

  void restoreExpense() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    File expenseBackup = File("${directory.path}/expenseBackup.json");
    String data = await expenseBackup.readAsString();
    List<Expense> list = [];
    print(data);
    List<dynamic> a = jsonDecode(data);
    a.forEach((val) {
      Map<String, dynamic> help = {};
      val.forEach((key, value) {
        help[key] = value;
      });
      print(help);
      list.add(Expense.fromJson(help["key"], help));
    });
    _expenses = list;
  }

  void clearExpenses() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/expenses');
    await ref.remove();

    _expenses = [];
    notifyListeners();
  }

  void addExpense({
    String? title,
    String? amount,
    int? createdAt,
    String? note,
    String? category,
    BuildContext? context,
  }) async {
    print("$title | $amount | $createdAt | $note | $category");

    Map<String, dynamic> newExpense = {
      "title": title,
      "amount": double.parse(amount!) * 100,
      "createdAt": createdAt,
      "note": note,
      "category": category
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/expenses')
        .push();
    await ref.set(newExpense);

    _expenses.add(Expense(
        title: title!,
        amount: (double.parse(amount) * 100).toString(),
        createdAt: createdAt.toString(),
        note: note!,
        category: category!,
        key: ref.key!));

    notifyListeners();
  }

  void editExpense({
    String title='',
    String amount ='',
    required int createdAt,
    String note ='',
    String category ='',
    BuildContext? context,
    String? key,
  }) async {
    print(key);
    Map<String, dynamic> newExpense = {
      "title": title,
      "amount": double.parse(amount!) * 100,
      "createdAt": createdAt,
      "note": note,
      "category": category
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/expenses/$key');
    await ref.set(newExpense);

    _expenses = _expenses.map((expense) {
      if (expense.key == key) {
        expense.amount = (double.parse(amount) * 100).toString();
        expense.title = title;
        expense.createdAt = createdAt.toString();
        expense.note = note;
        expense.category = category;
        return expense;
      } else {
        return expense;
      }
    }).toList();

    notifyListeners();
  }

  void deleteExpense(String key) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance
          .reference()
          .child('users/${_authUser?.uid}/expenses/$key');
      await ref.remove();

      _expenses.removeWhere((expense) => expense.key == key);
      notifyListeners();
      // Optionally show success feedback
    } catch (e) {
      print("Error deleting expense: $e");
      // Optionally show error feedback
    }
  }

}

mixin CCExpensesModel on CombinedModel {
  List<CCExpense> get ccAllExpenses {
    return List.from(_ccExpenses);
  }

  List<CCExpense> get ccfilteredExpenses {
    List<CCExpense> output = [];

    _ccExpenses.forEach((ccexpense) {
      // Provide a default empty list of categories if _userPreferences is null
      var categories = _userPreferences?.categories ?? [];
      Category category = categories.firstWhere(
            (category) => category.id == ccexpense.category,
        orElse: () => Category("0", "empty"), // Fallback category if none match
      );
      if (category.show || category.name == "empty") {
        output.add(ccexpense);
      }
    });

    List<CCExpense> rangeFilter = output;

    rangeFilter = output.where((ccexpense) {
      int expenseDate = int.parse(ccexpense.createdAt?? '0' );
      int _startDate = startDate?.millisecondsSinceEpoch ?? DateTime(1900).millisecondsSinceEpoch;
      int _endDate = endDate?.millisecondsSinceEpoch ?? DateTime(2100).millisecondsSinceEpoch;

      return expenseDate >= _startDate && expenseDate <= _endDate;
    }).toList();
  
    List<CCExpense> finalOutput = rangeFilter.where((ccexpense) {
      return ccexpense.title.toLowerCase().contains(_searchQuery) || ccexpense.creditCardName.toLowerCase().contains(_searchQuery) ||
          (ccexpense.note?? '').toLowerCase().contains(_searchQuery);
    }).toList();

    finalOutput.sort(
          (a, b) {
        // Handling null in date sorting
        if (_sortBy == "date") {
          var aCreatedAt = a.createdAt ?? ''; // Using empty string as fallback
          var bCreatedAt = b.createdAt ?? ''; // Using empty string as fallback
          return bCreatedAt.compareTo(aCreatedAt);
        }
        // Handling null in creditCardName sorting
        else if (_sortBy == "creditCardName") {
          var aName = a.creditCardName ?? ''; // Using empty string as fallback
          var bName = b.creditCardName ?? ''; // Using empty string as fallback
          return aName.compareTo(bName);
        }
        // Handling null in amount sorting
        else if (_sortBy == "amount") {
          var aAmount = a.amount != null ? double.tryParse(a.amount!) ?? 0.0 : 0.0;
          var bAmount = b.amount != null ? double.tryParse(b.amount!) ?? 0.0 : 0.0;
          return aAmount.compareTo(bAmount);
        }
        // Handling null in category sorting
        else if (_sortBy == "category") {
          var aCategory = a.category ?? ''; // Using empty string as fallback
          var bCategory = b.category ?? ''; // Using empty string as fallback
          return aCategory.compareTo(bCategory);
        } else {
          return 0; // Default fallback if none of the above conditions are met
        }
      },
    );

    return finalOutput;
  }

  void setCCExpenses(List<CCExpense> ccexpenses) {
    _ccExpenses = ccexpenses;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }

  void backupCCExpenses() async {
    // Testing Backup Feature!
    List<String> jsonList = [];
    String jv = jsonEncode(_ccExpenses);
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    File ccExpenseBackup = File("${directory.path}/ccexpenseBackup.json");
    ccExpenseBackup.writeAsString(jv).catchError((error) {
      print(error);
    });
  }

  void restoreCCExpense() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    File expenseBackup = File("${directory.path}/ccexpenseBackup.json");
    String data = await expenseBackup.readAsString();
    List<CCExpense> list = [];
    print(data);
    List<dynamic> a = jsonDecode(data);
    a.forEach((val) {
      Map<String, dynamic> help = {};
      val.forEach((key, value) {
        help[key] = value;
      });
      print(help);
      list.add(CCExpense.fromJson(help["key"], help));
    });
    _ccExpenses = list;
  }

  void clearCCExpenses() async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/ccexpenses');
    await ref.remove();

    _expenses = [];
    notifyListeners();
  }

  void addCCExpense({
    String title = '',
    String amount = '0',
    int? createdAt,
    String note = '',
    String creditCardName = '',
    String category = '',
    required BuildContext context,
  }) async {
    print("$title | $amount | $createdAt | $note | $category | $creditCardName");

    Map<String, dynamic> newExpense = {
      "title": title,
      "amount": double.parse(amount) * 100,
      "createdAt": createdAt,
      "note": note,
      "category": category,
      "creditCardName": creditCardName
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/ccexpenses')
        .push();
    await ref.set(newExpense);

    _ccExpenses.add(CCExpense(
        title,
        (double.parse(amount) * 100).toString(),
        createdAt.toString(),
        note,
        category,
        creditCardName,
        ref.key));

    notifyListeners();
  }

  void editCCExpense({
    String title = '',
    String amount = '0',
    int? createdAt,
    String note = '',
    String category= '',
    String creditCardName= '',
    required BuildContext context,
    required String key,
  }) async {
    print(key);
    Map<String, dynamic> newExpense = {
      "title": title,
      "amount": double.parse(amount) * 100,
      "createdAt": createdAt,
      "note": note,
      "category": category,
      "creditCardName": creditCardName
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/ccexpenses/$key');
    await ref.set(newExpense);

    _ccExpenses = _ccExpenses.map((expense) {
      if (expense.key == key) {
        expense.amount = (double.parse(amount) * 100).toString();
        expense.title = title;
        expense.createdAt = createdAt.toString();
        expense.note = note;
        expense.category = category;
        expense.creditCardName= creditCardName;
        return expense;
      } else {
        return expense;
      }
    }).toList();

    notifyListeners();
  }

  void deleteCCExpense(String key) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/ccexpenses/$key');
    await ref.remove();

    _expenses.removeWhere((expense) => expense.key == key);

    notifyListeners();
  }
}

mixin UserModel on CombinedModel {
  User? get authenticatedUser {
    return _authUser; // Ensure _authUser is of type User?
  }

  Future<void> changeUserName(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      updateUserName(name);
    }
  }

  void updateUserName(String newName) {
    if (_authUser != null) {
      User? user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    _authUser = null;
    _lastUpdated = null;
    _expenses.clear();
    _savingsAcc.clear();
    _creditCards.clear();
    _depositsAcc.clear();
    _ccExpenses.clear();
    toggleSynced();
    notifyListeners();
  }
}




mixin SavingsAccModel on CombinedModel {
  List<SavingsAcc> get ccAllSavingsAcc {
    return List.from(_savingsAcc);
  }

  List<SavingsAcc> get filteredSavingsAcc {
    List<SavingsAcc> output = [];
    print("Savings Acc Model");
    print(_savingsAcc);
    _savingsAcc.forEach(
          (savingsacc) {
        if (savingsacc != null) {
            output.add(savingsacc);
        }
      },
    );

    List<SavingsAcc> rangeFilter = output;
    List<SavingsAcc> finalOutput = rangeFilter.where((savingsacc) {
      return true;
    }).toList();

    return finalOutput;
  }

  void setSavingsAcc(List<SavingsAcc> savingsacc) {
    _savingsAcc = savingsacc;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }

  void addSavingsAcc({
    String accno = '',
    String bankName = '',
    String deposits = '0',
    String withdrawls ='0',
    String balance = '0',
    required BuildContext context,
  }) async {
    print("$accno | $bankName | $deposits | $withdrawls | $balance ");

    Map<String, dynamic> newSavingsAcc = {
      "accno": accno,
      "bankName": bankName,
      "deposits": double.parse(deposits) * 100,
      "withdrawls": double.parse(withdrawls) * 100,
      "balance": double.parse(balance) * 100,
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/bankacs/savings')
        .push();
    await ref.set(newSavingsAcc);

    _savingsAcc.add(SavingsAcc(
        accno: accno,
        bankName: bankName,
        deposits: (double.parse(deposits) * 100).toString(),
        withdrawls: (double.parse(withdrawls) * 100).toString(),
        balance: (double.parse(balance) * 100).toString(),
        key: ref.key!));

    notifyListeners();
  }

  void editSavingsAcc({
    String accno = '',
    String bankName= '',
    String deposits ='0',
    String withdrawls ='0',
    String balance ='0',
    required BuildContext context,
    String? key,
  }) async {
    print(key);
    Map<String, dynamic> newSavingsAcc = {
      "accno": accno,
      "bankName": bankName,
      "deposits": double.parse(deposits) * 100,
      "withdrawls": double.parse(withdrawls) * 100,
      "balance": double.parse(balance) * 100,
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/bankacs/savings/$key');
    await ref.set(newSavingsAcc);

    _savingsAcc = _savingsAcc.map((savings) {
      if (savings.key == key) {
        savings.deposits = (double.parse(deposits) * 100).toString();
        savings.accno = accno;
        savings.bankName = bankName;
        savings.withdrawls = (double.parse(withdrawls) * 100).toString();
        savings.balance = (double.parse(balance) * 100).toString();
        return savings;
      } else {
        return savings;
      }
    }).toList();

    notifyListeners();
  }

  void deleteSavingsAcc(String key) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/bankacs/savings/$key');
    await ref.remove();

    _savingsAcc.removeWhere((savings) => savings.key == key);

    notifyListeners();
  }
}


mixin DepositsAccModel on CombinedModel {
  List<DepositsAcc> get ccAllDepositsAcc {
    return List.from(_depositsAcc);
  }

  List<DepositsAcc> get filteredDepositsAcc {
    List<DepositsAcc> output = [];

    _depositsAcc.forEach(
          (depositsacc) {
        if (depositsacc != null) {
          output.add(depositsacc);
        }
      },
    );

    List<DepositsAcc> rangeFilter = output;
    List<DepositsAcc> finalOutput = rangeFilter.where((depositsacc) {
      return true;
    }).toList();

    return finalOutput;
  }

  void setDepositsAcc(List<DepositsAcc> depositsacc) {
    _depositsAcc = depositsacc;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }

  void addDepositsAcc({
    String accno = '',
    String bankName = '',
    String maturity ='',
    String principal ='',
    String rate= '',
    String term ='',

    required BuildContext context,
  }) async {
    print("$accno | $bankName | $maturity | $principal | $rate | $term ");

    Map<String, dynamic> newDepositsAcc = {
      "accno": accno,
      "bankName": bankName,
      "maturity": double.parse(maturity) * 100,
      "principal": double.parse(principal) * 100,
      "rate": double.parse(rate) * 100,
      "term": double.parse(term) * 100,
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/bankacs/deposits')
        .push();
    await ref.set(newDepositsAcc);

    _depositsAcc.add(DepositsAcc(
        accno: accno,
        bankName: bankName,
        maturity: (double.parse(maturity) * 100).toString(),
        principal: (double.parse(principal) * 100).toString(),
        rate: (double.parse(rate) * 100).toString(),
        term: (double.parse(term) * 100).toString(),
        key: ref.key?? ''));

    notifyListeners();
  }

  void editDepositsAcc({
    String accno= '',
    String bankName = '',
    String maturity = '',
    String principal = '',
    String rate = '',
    String term = '',
    required BuildContext context,
    String key = '',
  }) async {
    print(key);
    Map<String, dynamic> newDepositsAcc = {
      "accno": accno,
      "bankName": bankName,
      "principal": double.parse(principal) * 100,
      "maturity": double.parse(maturity) * 100,
      "rate": double.parse(rate) * 100,
      "term": double.parse(term) * 100,
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/bankacs/deposits/$key');
    await ref.set(newDepositsAcc);

    _depositsAcc = _depositsAcc.map((deposits) {
      if (deposits.key == key) {
        deposits.principal = (double.parse(principal) * 100).toString();
        deposits.accno = accno;
        deposits.bankName = bankName;
        deposits.maturity = (double.parse(maturity) * 100).toString();
        deposits.rate = (double.parse(rate) * 100).toString();
        deposits.term = (double.parse(term) * 100).toString();
        return deposits;
      } else {
        return deposits;
      }
    }).toList();

    notifyListeners();
  }

  void deleteDepositsAcc(String key) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/bankacs/deposits/$key');
    await ref.remove();

    _depositsAcc.removeWhere((deposits) => deposits.key == key);

    notifyListeners();
  }
}

mixin CreditCardsModel on CombinedModel {
  List<CreditCard> get ccAllCreditCards {
    return List.from(_creditCards);
  }

  void setCreditCard(List<CreditCard> creditCard) {
    _creditCards = creditCard;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }

  void addCreditCard({
    String bankName= '',
    String cardNumber= '',
    String cvv = '',
    String expiryMonth = '',
    String expiryYear = '',
    String nameOnCard = '',

    BuildContext? context,
  }) async {
    print("$cardNumber | $bankName | $cvv | $expiryYear | $expiryMonth | $nameOnCard ");

    Map<String, dynamic> newCreditCard = {
      "bankName": bankName,
      "cardNumber": cardNumber,
      "cvv": cvv,
      "expiryMonth": double.parse(expiryMonth) * 100,
      "expiryYear": double.parse(expiryYear) * 100,
      "nameOnCard": nameOnCard,
    };

    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('users/${_authUser?.uid}/creditcards')
        .push();
    await ref.set(newCreditCard);

    _creditCards.add(CreditCard(
        bankName : bankName,
        cardNumber: cardNumber,
        cvv: cvv,
        expiryMonth: (double.parse(expiryMonth) * 100).toString(),
        expiryYear: (double.parse(expiryYear) * 100).toString(),
        nameOnCard: nameOnCard,
        key: ref.key?? ''));

    notifyListeners();
  }

}
