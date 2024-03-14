import 'package:finalmo/config.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/profile/Owner_Apply.dart';
import 'package:finalmo/screen/profile/profileEdit.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = true;
  var username = '';
  late SharedPreferences prefs;
  var myToken;
  var jsonResponse;
  var userInfo;
  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    await initSharedPref();
    getUser();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  void getUser() async {
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

  void regisOwner() async {
    var regBody = {
      "userName": username,
    };

    var response = await http.post(Uri.parse(regOwner),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('สมัครเป็นผู้จัดก๊วนสำเร็จ'),
          content: const Text('สมัครเป็นผู้จัดก๊วนสำเร็จ'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'การตั้งค่า',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: new Icon(Icons.manage_accounts),
                        title: new Text('การตั้งค่าโปรไฟล์'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfileEdit()));
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.logout),
                        title: new Text('ออกจากระบบ'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.info),
                        title: new Text('เกี่ยวกับ'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('เกี่ยวกับ'),
                                ),
                                body: const Center(
                                  child: Text(
                                    'This is the next page',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            },
                          ));
                        },
                      ),
                      // DialogExample(),
                      ListTile(
                        leading: new Icon(Icons.supervisor_account),
                        title: new Text('สมัครเป็นผู้จัดก๊วน'),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             SettingProfile()));
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('สมัครเป็นผู้จัดก๊วน'),
                              content: const Text(
                                  'ต้องการสมัครเป็นผู้จัดก๊วนใช่หรือไม่'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    Navigator.pop(context, 'Cancel'),
                                    regisOwner()
                                  },
                                  child: const Text('ยืนยัน'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                            image: DecorationImage(
                              image: AssetImage(userInfo['picture']),
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // กำหนดให้เป็นรูปร่างวงกลม
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/user_default.png'),
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ]

                      // Container(
                      //   margin: EdgeInsets.all(8.0),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle, // กำหนดให้เป็นรูปร่างวงกลม
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/images/profile1.jpg'),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.all(8.0),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/images/profile3.jpg'),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.all(8.0),
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/images/profile4.jpg'),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
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
                            username,
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
