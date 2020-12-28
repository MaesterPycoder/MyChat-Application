import 'package:flutter/material.dart';
import 'package:mychat/Authentication/services.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _remail =
      TextEditingController(); // text field controller initiallization
  bool _mailSent = false; // bool for whetger Mail Sent  or not
  String _msg = "Mail Sent";
  AuthMethods _auth = AuthMethods();
  // Key for checking fields of form valid or not
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _resetRequest() async {
    if (_mailSent) {
      _msg = 'Mail Already Sent';
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        _mailSent = true;
      });
      // Sending the reset password mail to given mail
      await _auth.userResetPassword(_remail.text);
    }
  }

  _resetDetailsBody() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 25,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _remail,
              cursorColor: Colors.green,
              validator: (value) {
                String p =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(p);
                return regExp.hasMatch(value) ? null : "Invalid Mail";
              },
              decoration: InputDecoration(
                hintText: "Email",
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
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 25,
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
                'Reset',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _resetRequest();
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: _mailSent
                ? Center(
                    child: Text(
                      _msg,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Colors.indigo[900],
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: _resetDetailsBody(),
    );
  }
}
