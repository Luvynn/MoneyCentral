import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showSignUp = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();
  String _resetFormData = "";
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  final Map<String, String> _formData = {
    "email": '',
    "password": '',
    "confirmPassword": ''
  };

  void _authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Error in Google sign in" + e.toString()); // Consider using a more user-friendly error handling
    }
  }

  void _authenticateWithEmailandPassword(String _email, String _password) async {
    if (!_formKey.currentState!.validate()) return; // Ensuring the form is valid
    _formKey.currentState!.save();

    try {
      await _auth.signInWithEmailAndPassword(email: _email.trim(), password: _password);
      print(_auth);
      // Handle successful authentication
    } on FirebaseAuthException catch (e) {
      _buildSignInErrorDialog(e.message ?? "An error occurred. Please try again.");
    }
  }

  void _signUpWithEmailandPassword(String _email, String _password) async {
    if (!_formKey.currentState!.validate()) return; // Ensuring the form is valid
    if (_password != _confirmPassword) {
      _buildSignInErrorDialog("Passwords do not match.");
      return;
    }
    _formKey.currentState!.save();

    try {
      await _auth.createUserWithEmailAndPassword(email: _email.trim(), password: _password);
      // Handle successful sign up
    } on FirebaseAuthException catch (e) {
      _buildSignInErrorDialog(e.message ?? "An error occurred. Please try again.");
    }
  }

  _buildSignInErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          title: Text("Error"),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Text(
      "Money Central",
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.secondary,
        wordSpacing: 2.0,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (String? value) {
        if (value == null || value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
          return "Please enter a valid email address.";
        }
        return null; // Return null if the input is valid
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        hintText: "Email",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
      ),
      onSaved: (String? value) {
        _formData["email"] = value?? '';
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return "Please enter a valid password.";
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        helperText: _showSignUp ? "Minimum 8 characters" : "",
        hintText: "Password",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
      ),
      onSaved: (String? value) {
        _formData["password"] = value?? '';
      },
      obscureText: true,
    );
  }

  Widget _buildConfirmPassword() {
    return Column(
      children: <Widget>[
        TextFormField(
          validator: (String? value) {
            if (value==null || value.isEmpty ) {
              return "Please enter a valid password.";
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30.0),
            ),
            hintText: "Confirm Password",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: deviceTheme == "light" ? Colors.white : Colors.grey[600],
          ),
          onSaved: (String? value) {
            _formData["confirmPassword"] = value?? '';
          },
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        // Adjusted to use ThemeData to support both light and dark themes dynamically
        color: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[900],
      ),
      child: MaterialButton(
        onPressed: () async {
          // Ensure the form is valid before proceeding
          if (_resetFormKey.currentState?.validate() ?? false) {
            _resetFormKey.currentState?.save();

            // Attempt to send the password reset email
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: _resetFormData);
              Navigator.of(context).pop(); // Dismiss the current dialog

              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Reset Password"),
                    content: Text("If an account exists with the email provided, a reset link will be sent."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Okay"),
                      ),
                    ],
                  );
                },
              );
            } catch (e) {
              // Handle errors (e.g., network error, invalid email) here
              print(e); // Consider replacing this with user-friendly error handling
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.send, color: Colors.white),
            SizedBox(width: 10),
            Text("Send", style: TextStyle(color: Colors.white)),
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
            ? Theme.of(context).colorScheme.secondary
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

  _buildResetDialog() {
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
              "Reset Password",
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
                key: _resetFormKey,
                child: TextFormField(
                  onSaved: (String? value) => _resetFormData = value?? '',
                  validator: (String? value) {
                    if (value == null  ||
                        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                      return "Please enter a valid email address.";
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
                    hintText: "Email",
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
                _buildSaveButton(),
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
    final targetWidth = MediaQuery.of(context).size.width > 550.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.9;

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? widget, MainModel model) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: deviceTheme == "light"
                ? Theme.of(context).colorScheme.secondary
                : Colors.blue[700],
            elevation: 4.0,
            icon: Icon(MdiIcons.google),
            label: const Text('Login With Google'),
            onPressed: _authenticateWithGoogle,
          ),
          bottomNavigationBar: BottomAppBar(
            color: deviceTheme == "light" ? Colors.white : Colors.grey[750],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 80.0),
                    ),
                    IconButton(
                      icon:
                          Icon(_showSignUp ? MdiIcons.login : Icons.person_add),
                      onPressed: () {
                        setState(() {
                          _showSignUp = !_showSignUp;
                          _formData["email"] = '';
                          _formData["password"] = '';
                          _formData["confirmPassword"] = '';
                          _formKey.currentState?.reset();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Container(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: targetWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildHeader(),
                        SizedBox(
                          height: 10.0,
                        ),
                        _buildEmailField(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPasswordField(),
                        SizedBox(
                          height: 10,
                        ),
                        _showSignUp ? _buildConfirmPassword() : Container(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: deviceTheme == "light"
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.blue[700],
                          ),
                          child: MaterialButton(
                            onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _formKey.currentState!.save();

                                  if (_showSignUp) {
                                    if (_formData['password'] !=
                                        _formData['confirmPassword']) {
                                      _buildSignInErrorDialog(
                                          "Please enter matching passwords");
                                      return; // Stop further execution if passwords don't match
                                    }
                                    // Attempt to sign up
                                    _signUpWithEmailandPassword(
                                        _formData["email"]!,
                                        _formData["password"]!);
                                  } else {
                                    // Attempt to sign in
                                    _authenticateWithEmailandPassword(
                                        _formData["email"]!,
                                        _formData["password"]!);
                                  }
                                }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  _showSignUp ? "Sign Up" : "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          child: Text("Reset Password"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => _buildResetDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
