import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:finalmo/screen/home.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/login_page/signup.dart';

import 'package:finalmo/screen/myGang/myGang.dart';

import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final token;

  bool checkToken() {
    if (token != null) {
      if (JwtDecoder.isExpired(token) == false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  const MyApp({@required this.token, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
        home: (checkToken()) ? HomePage(token: token) : LoginScreen());
  }
}
