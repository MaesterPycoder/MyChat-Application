import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mychat/Authentication/services.dart';
import 'package:mychat/Authentication/signIn.dart';
import 'package:mychat/MainSection/chatsHome.dart';
import 'package:mychat/models/helperFunctions.dart';

// For verifying Mail of the user
class VerifyMailPage extends StatefulWidget {
  @override
  _VerifyMailPageState createState() => _VerifyMailPageState();
}

class _VerifyMailPageState extends State<VerifyMailPage> {
  AuthMethods _auth = new AuthMethods();
  Timer timer; // Initiallizing the timer
  bool isVerified = false; // Bool for checking mail verified or not
  int _checkAgain = 2; // time for rechecking verification status

  @override
  void initState() {
    _auth.verifyEmail(); // Sending verification Mail to user's registered Mail
    timer = Timer.periodic(Duration(seconds: _checkAgain), (timer) {
      _checkMailVerified(); // Checking whether Mail verified or not for every periodic time
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel(); // Disposing the timer
    super.dispose();
  }

  _goingToChatHome() {
    return ChatHome();
  }

  Future<void> _checkMailVerified() async {
    await _auth
        .reloadUser(); // reloading the current user to get updated status
    if (_auth.isEmailVerified) {
      setState(() {
        isVerified = true;
      });
      timer.cancel(); // Disposing the timer
      // Navigating to ChatHome upon mail verification
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        return _goingToChatHome();
      }));
    }
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
            Text("MyChat"),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 25,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Center(
              child: Icon(
                Icons.mail_outline_sharp,
                size: 200,
                color: Colors.yellow,
              ),
            ),
            Text(
              'Confirmation Mail has been sent to your registerred mail ID.',
              style: TextStyle(
                color: Colors.orange,
                fontFamily: 'DancingScript',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Text(
              'Please Check your Inbox',
              style: TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'DancingScript',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            isVerified
                ? Center(
                    child: SizedBox(),
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              child: Text(
                'Go back to Login Page',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
