import 'package:flutter/material.dart';
import 'package:mychat/Authentication/signIn.dart';
import 'package:mychat/models/helperFunctions.dart';
import 'package:mychat/MainSection/chatsHome.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn;
  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn != null
        ? (isLoggedIn ? ChatHome() : SignIn())
        : SignIn();
  }
}
