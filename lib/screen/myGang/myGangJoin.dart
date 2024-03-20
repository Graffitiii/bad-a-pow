// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'package:finalmo/screen/calender.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalmo/config.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MyGangJoin extends StatefulWidget {
  const MyGangJoin({super.key});

  @override
  State<MyGangJoin> createState() => _MyGangJoinState();
}

class _MyGangJoinState extends State<MyGangJoin> {
  late String username;
  late SharedPreferences prefs;
  var myToken;

  List<dynamic> eventPending = [];
  List<dynamic> eventJoin = [];
  List<Map<String, dynamic>> statusEventList = [];

  bool loading = true;

  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    await initSharedPref();
    await getPendingList();
    getJoinList();
  }

  Future<void> getPendingList() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getPendingEvent', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        eventPending = jsonResponse['data'];
      });
    } else {
      print("error getPendingList");
    }
  }

  void getJoinList() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getJoinEvent', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        eventJoin = jsonResponse['data'];
      });

      List<Map<String, dynamic>> pendingList =
          eventPending.cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> joinList =
          eventJoin.cast<Map<String, dynamic>>();

      for (var event in pendingList) {
        event['status'] = 'pending';
      }

      for (var event in joinList) {
        event['status'] = 'join';
      }

      statusEventList.addAll(pendingList);
      statusEventList.addAll(joinList);

      print("Combined Eventsกหดฟหำดำด: $statusEventList");

      setState(() {
        loading = false;
      });
    } else {
      print("error getJoinList");
    }
  }

  String formattingDate(start, end) {
    initializeDateFormatting('th', null);

    DateTime eventStart = DateTime.parse(start);
    DateTime eventEnd = DateTime.parse(end);

    DateTime thaiDateStartTime = eventStart.add(Duration(hours: 7));
    DateTime thaiDateEndTime = eventEnd.add(Duration(hours: 7));

    String formattedDateTime =
        DateFormat('d MMMM H:mm', 'th').format(thaiDateStartTime);

    String formattedEndTime =
        DateFormat('H:mm น.', 'th').format(thaiDateEndTime);

    return formattedDateTime + " - " + formattedEndTime;
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
    // print(username);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Calender()));
          },
          child: Row(
            children: [
              Spacer(),
              Text(
                'ตารางของฉันทั้งหมด',
                style: TextStyle(
                  color: Color(0xFF575757),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF575757),
                size: 16,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: statusEventList.map<Widget>((items) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              GangDetail(id: items['_id'])));
                },
                child: Material(
                  elevation: 5.0,
                  shadowColor: Color.fromARGB(192, 0, 0, 0),
                  borderRadius: new BorderRadius.circular(30),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Color(0xFFF5A201)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items['club']!,
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                            Row(children: [
                              Icon(
                                Icons.location_on,
                                color: Color(0xFFFF3333),
                                size: 20.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  'สนามเอสแอนด์เอ็ม จรัญ13 (12 กม.)',
                                  style: TextStyle(
                                    color: Color(0xFF929292),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Color(0xFF013C58),
                                  size: 20.0,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    formattingDate(items['eventdate_start'],
                                        items['eventdate_end']),
                                    // "sdasdaw",
                                    style: TextStyle(
                                      color: Color(0xFF929292),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            if (items['level'] != null &&
                                items['level'].isNotEmpty) ...[
                              Row(
                                children: [
                                  for (int i = 0;
                                      i < items['level'].length;
                                      i++)
                                    Container(
                                      margin: i > 0
                                          ? EdgeInsets.only(left: 10)
                                          : EdgeInsets.zero,
                                      height: 22,
                                      width: 22,
                                      decoration: BoxDecoration(
                                        color: items['level'][i] == 'N'
                                            ? Color(
                                                0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                            : items['level'][i] == 'S'
                                                ? Color(0x5B009020)
                                                : items['level'][i] == 'P'
                                                    ? Color(
                                                        0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                    : Color.fromARGB(
                                                        255, 222, 234, 255),
                                        borderRadius: BorderRadius.circular(
                                            7), // กำหนด radius ให้กรอบสี่เหลี่ยม
                                        border: Border.all(
                                          width: 2,
                                          color: items['level'][i] == 'N'
                                              ? Color(
                                                  0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                              : items['level'][i] == 'S'
                                                  ? Color(0xFF00901F)
                                                  : items['level'][i] == 'P'
                                                      ? Color(0xFFFC7FFF)
                                                      : Color(0xFFFC7FFF),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          items['level'][i],
                                          style: TextStyle(
                                            color: items['level'][i] == 'N'
                                                ? Color(
                                                    0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                : items['level'][i] == 'S'
                                                    ? Color(
                                                        0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                    : items['level'][i] == 'P'
                                                        ? Color(0xFFFC7FFF)
                                                        : Color(0xFFFC7FFF),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                            SizedBox(height: 5),
                            Row(children: [
                              Container(
                                child: Text(
                                  'สถานะ :',
                                  style: TextStyle(
                                    color: Color(0xFF929292),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              if (items['status'] == "pending") ...[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'รอการยืนยัน',
                                    style: TextStyle(
                                      color: Color(0xFFF5A201),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ] else if (items['status'] == "join") ...[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'ยืนยัน',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 99, 245, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ]
                            ]),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color.fromARGB(255, 255, 154, 3),
                                  size: 36.0,
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
