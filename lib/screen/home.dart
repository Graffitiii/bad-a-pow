// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:finalmo/config.dart';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/calender.dart';
import 'package:finalmo/screen/level_user.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:finalmo/screen/profile/story_event.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final token;
  const HomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  var myToken;
  late SharedPreferences prefs;
  var clubInfo;

  @override
  void initState() {
    initializeState();
    super.initState();
    // print(JwtDecoder.getRemainingTime(widget.token));
  }

  void initializeState() async {
    await initSharedPref();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);

    setState(() {
      username = jwtDecodedToken['userName'];
    });
  }

  void getClubDetail(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getClub', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        clubInfo = jsonResponse['club'];
      });
      print("clubInfo: $clubInfo");
    }
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
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    stops: [0.1, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF013C58), Color(0xFF0074AB)],
                  )),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ยินดีต้อนรับ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 5),
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
                      Opacity(
                        opacity: 0.80,
                        child: Container(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'สถานะ : Owner',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              )),
                          // width: 87,
                          // height: 17,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // logout();
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => TabBarViewFindEvent()),
                      //     );
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     primary: Color(0xFF013C58),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     elevation: 0, // Remove default button elevation
                      //   ),
                      //   child: Text(
                      //     'เริ่มหาก๊วน',
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
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
                              builder: (BuildContext context) => MyGang(
                                    numpage: 1,
                                  )));
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
                                Icons.how_to_reg,
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
                                Icons.admin_panel_settings,
                                size: 50,
                                color: Color(0xFF013C58),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "จัดการก๊วน",
                            ),
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
              ],
            ),

            SizedBox(
              height: 7,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // จัด Widget ทั้งหมดให้อยู่ข้างทางขวาและซ้าย
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('กิจกรรมใกล้ตัว'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabBarViewFindEvent(),
                            ),
                          );
                        },
                        child: Text('ดูทั้งหมด'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.0),
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 240.0,
                      child: Card(
                          elevation: 4, // เพิ่มเงากรอบ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // กำหนดรูปร่างของการ์ด
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'club',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Color(0xFFFF3333),
                                              size: 16.0,
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.5), // Adjust the value as needed
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  'placename',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.15), // Adjust the value as needed
                                              child: Container(
                                                child: Text(
                                                  "(กม.)",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFFF5A201),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF013C58),
                                              size: 16.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                // formattingDate(
                                                //     items[
                                                //         'eventdate_start'],
                                                //     items[
                                                //         'eventdate_end']),
                                                "sdasdaw",
                                                style: TextStyle(
                                                  color: Color(0xFF929292),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            'ดูกลุ่ม',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios, // เพิ่มไอคอน ios reward
                                            color: Colors.blue,
                                            size: 20, // ปรับขนาดไอคอนตามต้องการ
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 7,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // จัด Widget ทั้งหมดให้อยู่ข้างทางขวาและซ้าย
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('ประวัติการเข้าร่วมกิจกรรม'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabBarViewFindEvent(),
                            ),
                          );
                        },
                        child: Text('ดูทั้งหมด'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.0),
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 240.0,
                      child: Card(
                          elevation: 4, // เพิ่มเงากรอบ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // กำหนดรูปร่างของการ์ด
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'club',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Color(0xFFFF3333),
                                              size: 16.0,
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.5), // Adjust the value as needed
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  'placename',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.15), // Adjust the value as needed
                                              child: Container(
                                                child: Text(
                                                  "(กม.)",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFFF5A201),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF013C58),
                                              size: 16.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                // formattingDate(
                                                //     items[
                                                //         'eventdate_start'],
                                                //     items[
                                                //         'eventdate_end']),
                                                "sdasdaw",
                                                style: TextStyle(
                                                  color: Color(0xFF929292),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            'ดูกลุ่ม',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios, // เพิ่มไอคอน ios reward
                                            color: Colors.blue,
                                            size: 20, // ปรับขนาดไอคอนตามต้องการ
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      width: 240.0,
                      child: Card(
                          elevation: 4, // เพิ่มเงากรอบ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // กำหนดรูปร่างของการ์ด
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'club',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Color(0xFFFF3333),
                                              size: 16.0,
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.5), // Adjust the value as needed
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  'placename',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(
                                                              context)
                                                          .size
                                                          .width *
                                                      0.15), // Adjust the value as needed
                                              child: Container(
                                                child: Text(
                                                  "(กม.)",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFFF5A201),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Color(0xFF013C58),
                                              size: 16.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                // formattingDate(
                                                //     items[
                                                //         'eventdate_start'],
                                                //     items[
                                                //         'eventdate_end']),
                                                "sdasdaw",
                                                style: TextStyle(
                                                  color: Color(0xFF929292),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            'ดูกลุ่ม',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios, // เพิ่มไอคอน ios reward
                                            color: Colors.blue,
                                            size: 20, // ปรับขนาดไอคอนตามต้องการ
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      width: 200.0,
                      child: Card(
                          elevation: 4, // เพิ่มเงากรอบ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // กำหนดรูปร่างของการ์ด
                          ),
                          child: Column(
                            children: [
                              Wrap(
                                children: [
                                  ListTile(
                                    title: Text('Heading 1'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Sub Heading 1'),
                                        Text('รวยยย'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            'ดูกลุ่ม',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          Icon(
                                            Icons
                                                .arrow_forward_ios, // เพิ่มไอคอน ios reward
                                            color: Colors.blue,
                                            size: 20, // ปรับขนาดไอคอนตามต้องการ
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
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
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่ม
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // ให้ข้อความเริ่มต้นทางซ้ายของ Row
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // ให้เนื้อหาใน Column อยู่กึ่งกลางตามแนวดิ่ง
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserLevelScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'เช็คระดับผู้เล่นของคุณ',
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
                ),
              ),
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
