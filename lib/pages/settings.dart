import 'package:awesomeapp/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesomeapp/pages/module_main.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  String _nameFormData ='';
  bool darkThemeVal = false;

  @override
  void initState() {
    super.initState();
    _nameFormData = "";
    darkThemeVal = deviceTheme == "light" ? false : true;
  }

  void _onHomePressed() {
    print("Home button clicked");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ModulesPage(),
      ),
    );
  }

  _buildSaveButton(Function changeName) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: deviceTheme == "light"
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[900],
      ),
      child: MaterialButton(
        onPressed: () {
          if (_nameFormKey.currentState?.validate() ?? false) {
            // If the form is valid, save the form state. This triggers the onSaved properties in the form fields.
            _nameFormKey.currentState?.save();

            // Proceed with your logic after form is validated and saved, such as navigating to another screen or showing a dialog.
            print("Form is valid and saved.");
          } else {
            // Logic to handle when the form is invalid.
            print("Form is not valid.");
          }
          changeName(_nameFormData);
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCancelButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: deviceTheme == "light"
            ? Theme.of(context).cardColor
            : Colors.grey[900],
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildNameDialog(Function changeName) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 200,
        width: 500,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              "Change Name",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              clipBehavior: Clip.none,
              elevation: 3.0,
              margin: EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Form(
                key: _nameFormKey,
                child: TextFormField(
                  onSaved: (String? value) => _nameFormData = value!,
                  validator: (String? value) {
                    if (value== null || value.length == 0) {
                      return "Please enter a name to continue";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: "Display Name",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefix: Text("  "),
                    filled: true,
                    fillColor: deviceTheme == "light"
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildSaveButton(changeName),
                SizedBox(
                  width: 10,
                ),
                _buildCancelButton()
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        print(model.authenticatedUser);
        return Scaffold(
          body: GestureDetector(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: deviceTheme == "light"
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[900],
                  pinned: false,
                  floating: false,
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                      child: SafeArea(
                        bottom: false,
                        top: true,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Settings",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    MdiIcons.logout,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    await GoogleSignIn().signOut();
                                    await FirebaseAuth.instance.signOut();
                                    model.logoutUser();
                                    restartApp();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue[700],
                                      foregroundColor: Colors.white,
                                      child: Text(model.authenticatedUser?.displayName?? 'default'),
                                    ),
                                    width: 50.0,
                                    height: 50.0,
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: new BoxDecoration(
                                      color:
                                      const Color(0xFFFFFFFF), // border color
                                      shape: BoxShape.circle,
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        print("PRESS");
                                      },
                                      child: Text(
                                          model.authenticatedUser?.displayName?? "Add Name",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      model.authenticatedUser?.email?? 'no"email.com',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
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
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.only(left: 7),
                            child: Text(
                              "Account Settings",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        color: deviceTheme == "light"
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[900],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          title: Text("User Name"),
                          subtitle: Text(model.authenticatedUser?.displayName?? 'default'),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildNameDialog(model.changeUserName),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          title: Text("Reset Password"),
                          trailing: IconButton(
                            icon: Icon(MdiIcons.restore),
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: model.authenticatedUser?.email?? 'no@email.com');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Password reset sent to registered email address."),
                                  backgroundColor: deviceTheme == "light"
                                      ? Colors.blueAccent
                                      : Colors.blue[800],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              "Display",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        color: deviceTheme == "light"
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[900],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: SwitchListTile(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          onChanged: (bool value) async {
                            if (!value) {
                              model.updateTheme("light");
                              SharedPreferences pref =
                              await SharedPreferences.getInstance();
                              await pref.setString("theme", "light");
                              restartApp();
                            } else {
                              model.updateTheme("dark");
                              SharedPreferences pref =
                              await SharedPreferences.getInstance();
                              await pref.setString("theme", "dark");
                              restartApp();
                            }
                          },
                          value: darkThemeVal,
                          title: Text("Dark Theme"),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              "Preferences",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        color: deviceTheme == "light"
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[900],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          title: Text("Currency"),
                          subtitle: Text(model.userCurrency??"Loading preferences"),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: model.userCurrency == null
                                ? null
                                : () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 200,
                                    child: ListView(
                                      children: <Widget>[
                                        RadioListTile(
                                          groupValue: model.userCurrency,
                                          value: "£",
                                          title: Text("Pounds (£)"),
                                          activeColor:
                                          Theme.of(context).colorScheme.secondary,
                                          onChanged: (String? value) {
                                            model.updateCurrency(value!);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        RadioListTile(
                                          groupValue: model.userCurrency,
                                          value: "\$",
                                          title: Text("Dollars (\$)"),
                                          activeColor:
                                          Theme.of(context).colorScheme.secondary,
                                          onChanged: (String? value) {
                                            model.updateCurrency(value!);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        RadioListTile(
                                          groupValue: model.userCurrency,
                                          value: "€",
                                          title: Text("Euros (€)"),
                                          activeColor:
                                          Theme.of(context).colorScheme.secondary,
                                          onChanged: (String? value) {
                                            model.updateCurrency(value!);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            padding: EdgeInsets.only(left: 7.0),
                            child: Text(
                              "Manage Your Data",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        color: deviceTheme == "light"
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[900],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          title: Text("Clear All Expenses"),
                          subtitle: model.allExpenses.length == 0
                              ? Text("No expenses found.")
                              : Text("Warning: This action is permanent."),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: model.allExpenses.length == 0
                                ? null
                                : () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete All Expenses"),
                                    content: Text(
                                        "Are you sure you want to delete all expenses. Warning this action is irreversible."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          "Delete All",
                                          style:
                                          TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          model.clearExpenses();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          title: Text("Backup All Expenses"),
                          subtitle: model.allExpenses.length == 0
                              ? Text("No expenses found.")
                              : Text("Save expenses locally."),
                          trailing: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: model.allExpenses.length == 0
                                ? null
                                : () {
                              model.backupExpenses();
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3.0),
                        color: deviceTheme == "light"
                            ? Colors.white
                            : Colors.grey[800],
                        child: ListTile(
                          title: Text("Restore All Expenses"),
                          subtitle: model.allExpenses.length == 0
                              ? Text("No expenses found.")
                              : Text("Load expenses from file."),
                          trailing: IconButton(
                            icon: Icon(Icons.restore),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Restore Expenses"),
                                    content: Text(
                                        "Are you sure you want to overwrite all expenses. Warning this action is irreversible."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          "Restore",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          model.restoreExpense();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: deviceTheme == "light" ? Colors.white : Colors.grey[900],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                        Icons.home,
                        size: 30,
                        color: Theme.of(context).colorScheme.secondary
                    ),
                    onPressed: _onHomePressed,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }
}
