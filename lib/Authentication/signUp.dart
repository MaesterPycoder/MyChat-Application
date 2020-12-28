import 'package:flutter/material.dart';
import 'package:mychat/Authentication/mailVerification.dart';
import 'package:mychat/Authentication/signIn.dart';
import 'package:mychat/Authentication/services.dart';
import 'package:mychat/DataBases/database.dart';
import 'package:mychat/models/helperFunctions.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userName =
      TextEditingController(); // UserName section controller
  TextEditingController userMail =
      TextEditingController(); // User Mail section controller
  TextEditingController password =
      TextEditingController(); // password section controller
  TextEditingController cPassword =
      TextEditingController(); // Confirm password section controller
  final _formKey =
      GlobalKey<FormState>(); // Checking entered details validation
  dynamic result;
  final AuthMethods _auth = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool _hidePassword = true; // Hiding password as per user request
  bool _isLoading = false; // Indicating busy State

  Color getColor(Set<MaterialState> states) {
    // material colors defining
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

// Method for showing dialog
  Future<void> _showDialog(String msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Alert!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Text(
                msg,
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }

// Method for sending request to create new user
  signMeUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result =
          await _auth.userSignUpEmailAndPassword(userMail.text, password.text);

      if (result == 'email-already-in-use') {
        setState(() {
          _isLoading = false;
        });
        _showDialog('This Email already in Use. Please Login').then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignIn(),
            ),
          ),
        );
      } else if (result == 'invalid-email') {
        setState(() {
          _isLoading = false;
        });
        _showDialog('Invalid Email');
        userMail.clear();
        password.clear();
        cPassword.clear();
      } else if (result == 'operation-not-allowed') {
        setState(() {
          _isLoading = false;
        });
        _showDialog(
            'This ${userMail.text} is not allowed. Please contact administrator');
      } else if (result == 'weak-password') {
        setState(() {
          _isLoading = false;
        });
        _showDialog('Your password is Very weak');
        cPassword.clear();
        password.clear();
      } else {
        setState(() {
          _isLoading = false;
        });
        Map<String, String> userMap = {
          "Name": userName.text,
          "email": userMail.text
        };
        // Add to Shared Preference
        HelperFunctions.saveUserUserNameSharedPreference(userName.text);
        HelperFunctions.saveUserMailSharedPreference(userMail.text);
        dataBaseMethods.uploadUserInfo(userMap);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyMailPage(),
          ),
        );
      }
    } else {
      cPassword.clear();
      _showDialog('Password Mismatch');
    }
  }

// Method for designing UI for sign up page
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
            Text("MyChat - SignUp"),
          ],
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : null,
            ),
            Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'DancingScript'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: userName,
                    validator: (value) {
                      return (value.isEmpty) ? "Please Enter User Name" : null;
                    },
                    decoration: InputDecoration(
                      hintText: 'User Name',
                      prefixIcon: Icon(Icons.supervised_user_circle,
                          color: Colors.indigo),
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
                    controller: userMail,
                    validator: (value) {
                      String p =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(p);
                      return regExp.hasMatch(value) ? null : "Invalid Mail";
                    },
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.mail, color: Colors.indigo),
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
                    obscureText: _hidePassword,
                    obscuringCharacter: '*',
                    validator: (value) {
                      return (password.text.length > 6)
                          ? null
                          : "Password length must be greator than 6";
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      enabled: true,
                      prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        child: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: !_hidePassword ? Colors.green : Colors.red,
                        ),
                      ),
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
                    controller: cPassword,
                    obscureText: _hidePassword,
                    obscuringCharacter: '*',
                    validator: (value) {
                      return (password.text == cPassword.text)
                          ? null
                          : "Mismatch";
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.indigo),
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
              height: 10,
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
                  'Sign-Up',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if ((password.text).isEmpty ||
                      (cPassword.text).isEmpty ||
                      (userMail.text).isEmpty) {
                    _showDialog('Please, Enter all the Sections');
                  } else {
                    signMeUp();
                  }
                }, // Implement this
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  autofocus: true,
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.resolveWith(getColor),
                  ),
                  child: Text(
                    'Sign-In Now',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  }, // Implement this
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
