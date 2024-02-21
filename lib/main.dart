import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:finalmo/screen/login_page/login.dart';

import 'package:finalmo/screen/myGang/myGang.dart';

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
        theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
        home: LoginScreen());
  }
}
