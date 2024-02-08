import 'package:finalmo/screen/forgetpassword.dart';
import 'package:finalmo/screen/login.dart';
import 'package:finalmo/screen/signup.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: Profile());
  }
}
