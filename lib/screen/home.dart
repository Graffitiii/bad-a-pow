// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:finalmo/config.dart';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/calender.dart';
import 'package:finalmo/screen/level_user.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:finalmo/screen/profile/history_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
  var historyData;
  bool loadingHis = true;
  bool ou = true;

  @override
  void initState() {
    initializeState();
    super.initState();

    // print(JwtDecoder.getRemainingTime(widget.token));
  }

  void initializeState() async {
    await initSharedPref();
    getHistory();
    permission();
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

  void getHistory() async {
    var queryParameters = {'username': username, 'limit': '3'};

    var uri = Uri.http(getUrl, '/findHistory', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        historyData = jsonResponse['result'];
      });

      print(historyData);
      setState(() {
        loadingHis = false;
      });
    }
  }

  void permission() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getUserControl', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);
    ou = jsonResponse['data']['ownerPermission'];
    print(ou);
  }

  String formattingDate(start, end) {
    initializeDateFormatting('th', null);

    DateTime eventStart = DateTime.parse(start);
    DateTime eventEnd = DateTime.parse(end);
    // print(eventStart);
    DateTime thaiDateStartTime = eventStart.add(Duration(hours: 7));
    DateTime thaiDateEndTime = eventEnd.add(Duration(hours: 7));

    String formattedDateTime =
        DateFormat('d MMMM H:mm', 'th').format(thaiDateStartTime);

    String formattedEndTime =
        DateFormat('H:mm น.', 'th').format(thaiDateEndTime);

    // print(formattedDateTime + "-" + formattedEndTime);
    return formattedDateTime + " - " + formattedEndTime;
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
        body: Padding(
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
                        if (ou) ...[
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
                        ] else ...[
                          Opacity(
                            opacity: 0.80,
                            child: Container(
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'สถานะ : User',
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
                        ],
                      ],
                    )),
              ),
              SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        child: Material(
                          elevation: 5.0,
                          shadowColor: Color.fromARGB(255, 0, 0, 0),
                          borderRadius: new BorderRadius.circular(30),
                          child: TextFormField(
                            // onChanged: onQueryChanged,

                            decoration: InputDecoration(
                              hintText: 'ค้นหากิจกรรม',
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              border: InputBorder.none,
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.0, color: Colors.red),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.0, color: Colors.red),
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
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.favorite,
                                          size: 40,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                            TabBarViewMyEvent1()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.how_to_reg,
                                          size: 40,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                            TabBarViewProfile(
                                              sos: true,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.admin_panel_settings,
                                          size: 40,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                                        builder: (BuildContext context) =>
                                            Calender()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 40,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
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
                      if (loadingHis) ...[
                        CircularProgressIndicator()
                      ] else ...[
                        if (historyData.length == 0) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TabBarViewFindEvent()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(234, 245, 255, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ดูเหมือนวันคุณยังไม่เคยเข้าร่วมกิจกรรมไหน',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 66, 66, 66),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start, // ให้ข้อความเริ่มต้นทางซ้ายของ Row
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // ให้เนื้อหาใน Column อยู่กึ่งกลางตามแนวดิ่ง
                                      children: [
                                        Text(
                                          'เริ่มหาก๊วนเลย!',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 66, 66, 66),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Column(
                            children: [
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
                                          child:
                                              Text('ประวัติการเข้าร่วมกิจกรรม',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 66, 66, 66),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  )),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HistoryScreen(),
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
                                    children: historyData.map<Widget>((items) {
                                      return Container(
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
                                                        items['clubname'],
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF013C58),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Color(
                                                                    0xFFFF3333),
                                                                size: 16.0,
                                                              ),
                                                              ConstrainedBox(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.4), // Adjust the value as needed
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    items[
                                                                        'placename'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF929292),
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
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
                                                                Icons
                                                                    .calendar_month,
                                                                color: Color(
                                                                    0xFF013C58),
                                                                size: 16.0,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  formattingDate(
                                                                      items[
                                                                          'eventdate_start'],
                                                                      items[
                                                                          'eventdate_end']),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF929292),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
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
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'ดูกลุ่ม',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios, // เพิ่มไอคอน ios reward
                                                              color:
                                                                  Colors.blue,
                                                              size:
                                                                  20, // ปรับขนาดไอคอนตามต้องการ
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],

                      SizedBox(
                        height: 20,
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
                                            builder: (context) =>
                                                UserLevelScreen(),
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
                ),
              ),
            ],
          ),
        ));
  }
}
