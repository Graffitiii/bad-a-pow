// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:finalmo/screen/home.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/login_page/signup.dart';

import 'package:finalmo/screen/myGang/myGang.dart';

import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // if (Platform.isAndroid) {
  //   AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  // }
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
        theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: "Noto"),
        home: (checkToken()) ? TabBarViewBottom() : LoginScreen());
  }
}
