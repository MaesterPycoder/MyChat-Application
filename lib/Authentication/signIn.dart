import 'package:flutter/material.dart';
import 'package:mychat/Authentication/mailVerification.dart';
import 'package:mychat/Authentication/passwordResetPage.dart';
import 'package:mychat/Authentication/services.dart';
import 'package:mychat/Authentication/signUp.dart';
import 'package:mychat/DataBases/database.dart';
import 'package:mychat/MainSection/chatsHome.dart';
import 'package:mychat/models/helperFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController userMail = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _errorOccurred = false;
  bool _hidePassword = true;
  String msg;
  AuthMethods _auth = new AuthMethods();
  DataBaseMethods databaseMethods = DataBaseMethods();
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.blue;
  }

  signMeUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
        _errorOccurred = false;
      });

      dynamic result =
          await _auth.userSignInEmailAndPassword(userMail.text, password.text);

      if (result == 'invalid-email') {
        userMail.clear();
        password.clear();
        setState(() {
          msg = 'Invalid Email';
          _isLoading = false;
          _errorOccurred = true;
        });
      } else if (result == 'user-disabled') {
        userMail.clear();
        password.clear();
        setState(() {
          msg = 'Your Account Disabled by Administrator';
          _isLoading = false;
          _errorOccurred = true;
        });
      } else if (result == 'wrong-password') {
        password.clear();
        setState(() {
          msg = 'Wrong Password';
          _isLoading = false;
          _errorOccurred = true;
        });
      } else if (result == 'user-not-found') {
        userMail.clear();
        password.clear();
        setState(() {
          msg = 'User Not Found';
          _isLoading = false;
          _errorOccurred = true;
        });
      } else if (result != "network-request-failed") {
        // Navigating to mail verification page if user's mail is not verified
        QuerySnapshot userInfoSnapshot =
            await databaseMethods.getUserInfo(userMail.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _auth.isEmailVerified
                ? _goingChatHome(userInfoSnapshot)
                : _goingVerifyMailPage(userInfoSnapshot),
          ),
        );
      } else {
        //:Resolve if device is offline <BUG>
      }
    }
  }

  _goingChatHome(QuerySnapshot userInfoSnapshot) {
    HelperFunctions.saveUserUserNameSharedPreference(
        userInfoSnapshot.docs.first.get("Name"));
    HelperFunctions.saveUserMailSharedPreference(
        userInfoSnapshot.docs.first.get("email"));
    HelperFunctions.saveUserLoggedInSharedPreference(true);
    return ChatHome();
  }

  _goingVerifyMailPage(QuerySnapshot userInfoSnapshot) {
    HelperFunctions.saveUserUserNameSharedPreference(
        userInfoSnapshot.docs.first.get("Name"));
    HelperFunctions.saveUserMailSharedPreference(
        userInfoSnapshot.docs.first.get("email"));
    HelperFunctions.saveUserLoggedInSharedPreference(true);
    return VerifyMailPage();
  }

// Method for indicating busy state
  Widget _waitingStateWindow() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

// Main UI design for signing in Screen
  Widget _showFillingSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 25,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: _errorOccurred
                ? Center(
                    child: Text(
                      msg,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : null,
          ),
          Center(
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'DancingScript'),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  cursorColor: Colors.green,
                  validator: (value) {
                    String p =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(p);
                    return regExp.hasMatch(value) ? null : "Invalid Mail";
                  },
                  controller: userMail,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.indigo,
                    ),
                    enabled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigoAccent,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  controller: password,
                  cursorColor: Colors.green,
                  obscureText: _hidePassword,
                  obscuringCharacter: '*',
                  validator: (value) =>
                      value.isEmpty ? "Please Enter Password" : null,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      child: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: !_hidePassword ? Colors.green : Colors.red,
                      ),
                    ),
                    enabled: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigoAccent,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              focusColor: Colors.indigo,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()));
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 10,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RaisedButton(
              color: Colors.indigo[800],
              highlightColor: Colors.indigoAccent[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(style: BorderStyle.solid),
              ),
              child: Text(
                'Sign-In',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: signMeUp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Doesn't have an account?",
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 15,
                ),
              ),
              TextButton(
                autofocus: true,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith(getColor),
                ),
                child: Text(
                  'Register Now',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Row(
          children: [
            Icon(Icons.chat_bubble),
            SizedBox(
              width: 10,
            ),
            Text("MyChat - SignIn"),
          ],
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: _isLoading ? _waitingStateWindow() : _showFillingSection(),
    );
  }
}
