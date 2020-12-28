import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mychat/wrapper.dart';

// Main Function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyChat());
}

// MyChart app Starting Material design
class MyChat extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyChart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: Wrapper(), // Initialling Calling Page
    );
  }
}
