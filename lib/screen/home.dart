// ignore_for_file: prefer_const_constructors

import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/calender.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final token;
  const HomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String username;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['userName'];
    print(JwtDecoder.getRemainingTime(widget.token));
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void logout() {
    prefs.remove('token');
    print('logout');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TabBarViewBottom()),
    // );
  }

  _launchURL() async {
    const url =
        'https://th.wikipedia.org/wiki/%E0%B9%81%E0%B8%9A%E0%B8%94%E0%B8%A1%E0%B8%B4%E0%B8%99%E0%B8%95%E0%B8%B1%E0%B8%99'; // URL ที่คุณต้องการเปิด
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "หน้าหลัก",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('assets/images/badHome.jpg'),
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 56, 56, 56),
                    BlendMode.hardLight,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'หาก๊วนกันเลย!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // logout();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabBarViewFindEvent()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF013C58),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0, // Remove default button elevation
                        ),
                        child: Text(
                          'เริ่มหาก๊วน',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Material(
                elevation: 5.0,
                shadowColor: Color.fromARGB(255, 0, 0, 0),
                borderRadius: new BorderRadius.circular(30),
                child: TextFormField(
                  // onChanged: onQueryChanged,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Icon(Icons.search),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fillColor: Color(0xFFF4F4F4),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: InputBorder.none,
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.red),
                    ),
                    errorStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Calender()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Add border radius
                              border: Border.all(
                                color: Color(
                                    0xFFF0F0F0), // Choose your border color
                                width: 5, // Specify the width of the border
                              ),
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Color(0xFFF0F0F0),
                              child: Icon(
                                Icons.calendar_month,
                                size: 50,
                                color: Color(0xFF013C58),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("ตารางกิจกรรม"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TabBarViewMyEvent()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Add border radius
                              border: Border.all(
                                color: Color(
                                    0xFFF0F0F0), // Choose your border color
                                width: 5, // Specify the width of the border
                              ),
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Color(0xFFF0F0F0),
                              child: Icon(
                                Icons.favorite,
                                size: 50,
                                color: Color(0xFF013C58),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("กลุ่มที่ติดตาม"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TabBarViewMyEvent()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Add border radius
                              border: Border.all(
                                color: Color(
                                    0xFFF0F0F0), // Choose your border color
                                width: 5, // Specify the width of the border
                              ),
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Color(0xFFF0F0F0),
                              child: Icon(
                                Icons.calendar_month,
                                size: 50,
                                color: Color(0xFF013C58),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("ที่เข้าร่วม"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TabBarViewProfile()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  15), // Add border radius
                              border: Border.all(
                                color: Color(
                                    0xFFF0F0F0), // Choose your border color
                                width: 5, // Specify the width of the border
                              ),
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              color: Color(0xFFF0F0F0),
                              child: Icon(
                                Icons.calendar_month,
                                size: 50,
                                color: Color(0xFF013C58),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text("เป็นผู้จัดก๊วน"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('assets/images/badHome.jpg'),
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(255, 56, 56, 56),
                    BlendMode.hardLight,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่ม
                        },
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                _launchURL();
                              },
                              child: Text(
                                'ความรู้แบดมินตันเบื้องต้น',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            // Text(
            //   widget.token,
            //   style: TextStyle(
            //     color: const Color.fromARGB(255, 0, 0, 0),
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //     height: 0,
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}
