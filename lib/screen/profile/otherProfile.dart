import 'package:finalmo/config.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/profile/Owner_Apply.dart';
import 'package:finalmo/screen/profile/history_event.dart';
import 'package:finalmo/screen/profile/profileEdit.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OProfile extends StatefulWidget {
  final username;
  const OProfile({this.username, super.key});

  @override
  State<OProfile> createState() => _OProfileState();
}

class _OProfileState extends State<OProfile> {
  bool loading = true;
  var username = '';
  late SharedPreferences prefs;
  var myToken;
  var jsonResponse;
  var userInfo;
  @override
  void initState() {
    getUser(widget.username);
    super.initState();
  }

  Future<void> getUser(username) async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getUser', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        userInfo = jsonResponse['data'];
      });
      print(userInfo);

      setState(() {
        loading = false;
      });
    } else {}
  }

  String calculateAge(String birthdate) {
    DateTime today = DateTime.now();
    DateTime birthDate = DateTime.parse(birthdate);

    int age = today.year - birthDate.year;
    int month1 = today.month;
    int month2 = birthDate.month;

    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = today.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "โปรไฟล์",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
      ),
      body: SingleChildScrollView(
        child: loading
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CarouselSlider(
                    items: [
                      if (userInfo['picture'] != '') ...[
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // กำหนดให้เป็นรูปร่างวงกลม
                          ),
                          child: ClipOval(
                              child: SizedBox.fromSize(
                            size: Size.fromRadius(105),
                            child: Image.network(
                              userInfo['picture'],
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          )),
                        ),
                      ] else ...[
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // กำหนดให้เป็นรูปร่างวงกลม
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/user_default.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ]
                    ],
                    options: CarouselOptions(
                      height: 230.0,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            userInfo['userName'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: Row(
                                children: [
                                  Text(
                                    'เพศ',
                                    style: TextStyle(
                                      color: Color(0xFF013C58),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  if (userInfo['gender'] != '') ...[
                                    Text(
                                      userInfo['gender'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      'ไม่ระบุ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: Row(
                                children: [
                                  Text(
                                    'อายุ',
                                    style: TextStyle(
                                      color: Color(0xFF013C58),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(width: 100),
                                  if (userInfo['ageShow']) ...[
                                    Text(
                                      calculateAge(userInfo['birthDate']),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      'ไม่ระบุ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                  SizedBox(width: 100),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: Row(
                                children: [
                                  Text(
                                    'ระดับฝีมือ',
                                    style: TextStyle(
                                      color: Color(0xFF013C58),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(width: 60),
                                  if (userInfo['level'] != '') ...[
                                    Text(
                                      userInfo['level'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      'ไม่ระบุ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                  SizedBox(width: 60),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              child: Row(
                                children: [
                                  Text(
                                    'คำอธิบายตัวเอง',
                                    style: TextStyle(
                                      color: Color(0xFF013C58),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 30),
                              child: Row(
                                children: [
                                  if (userInfo['about'] != '') ...[
                                    Text(
                                      userInfo['about'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ] else ...[
                                    Expanded(
                                      child: Text(
                                        'ไม่ระบุ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
