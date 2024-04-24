// ignore_for_file: prefer_const_constructors

import 'package:finalmo/screen/Event/gangDetail.dart';
import 'package:finalmo/screen/Event/gangOwnerDetail.dart';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/myGang/addclub.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGangOwner extends StatefulWidget {
  const MyGangOwner({super.key});

  @override
  State<MyGangOwner> createState() => _MyGangOwnerState();
}

class _MyGangOwnerState extends State<MyGangOwner> {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  var jsonResponse;
  bool status = false;
  bool loading = false;
  var reviewlist = {};
  // var rating = '';
  Map<String, String> review = {};

  void initState() {
    // TODO: implement initState
    initializeState();

    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // userId = jwtDecodedToken['_id'];
  }

  void initializeState() async {
    await initSharedPref();
    getClubList();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  void getClubList() async {
    print(username);
    setState(() {
      loading = true;
    });
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getOwnerClub', queryParameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);

      print(jsonResponse);
      status = true;

      List<Future> reviewFutures = [];

      for (var club in jsonResponse['Owner']) {
        // Call getReview for each club and store the future
        reviewFutures.add(getReview(club['clubname']));
      }

      for (var club in jsonResponse['Admin']) {
        // Call getReview for each club and store the future
        reviewFutures.add(getReview(club['clubname']));
      }

      // Wait for all futures to complete
      await Future.wait(reviewFutures);

      print(review);
      setState(() {
        loading = false;
      });
    } else {
      status = true;

      print(response.statusCode);
    }
  }

  Future<void> getReview(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getReviewList', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        reviewlist = jsonResponse;
        // print(averageScore(reviewlist));
        review[clubname] = averageScore(reviewlist);
      });
    }

    setState(() {
      loading = false;
    });
  }

  String averageScore(reviewlist) {
    var rating = '';
    int sum = 0;
    int count = reviewlist['success'].length;

    for (var value in reviewlist['success']) {
      int score = value['score'];
      sum += score;
    }

    double average = count > 0 ? sum / count : 0;
    String formattedAverage = average.toStringAsFixed(1);
    // print('Average Score: $formattedAverage');
    rating = formattedAverage;
    return rating;
  }

  void addClubHandle() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getUserControl', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      if (jsonResponse['data']['ownerPermission']) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddClub(
              username: username,
            );
          },
        );
      } else {
        showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('ไม่สามารถสร้างก๊วนได้ '),
            content: const Text(
              'เนื่องจากคุณไม่ได้เป็นสมาชิกของ “ผู้จัดก๊วน”',
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ปิด'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabBarViewProfile(
                                  sos: true,
                                )),
                      );
                    },
                    child: const Text('สมัครเป็นผู้จัดก๊วน'),
                  ),
                ],
              )
            ],
          ),
        );
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addClubHandle(); // เรียกใช้งาน addClubHandle โดยส่ง context เข้าไป
        },
        tooltip: 'สร้างกลุ่ม',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: CircleBorder(), // เปลี่ยนรูปร่างเป็นวงกลม
        elevation: 8,
        backgroundColor: Color(0xFF00537A),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          child: Center(
            child: loading
                ? CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        Container(
                          child: !status
                              ? Text("Error: ")
                              : Column(
                                  children: [
                                    ...jsonResponse['Owner'].map<Widget>(
                                      (items) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          GangOwnerDetail(
                                                              club: items[
                                                                  'clubname'])));
                                            },
                                            child: Material(
                                              elevation: 5.0,
                                              shadowColor:
                                                  Color.fromARGB(192, 0, 0, 0),
                                              borderRadius:
                                                  new BorderRadius.circular(30),
                                              child: Container(
                                                height: 130,
                                                width: double.infinity,
                                                decoration: ShapeDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 2,
                                                        color:
                                                            Color(0xFFF5A201)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Row(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // ignore: prefer_const_constructors
                                                        Text(
                                                          items['clubname'],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Row(children: [
                                                          Icon(
                                                            Icons
                                                                .admin_panel_settings,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    154,
                                                                    3),
                                                            size: 20.0,
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              items['owner'],
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF929292),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Row(children: [
                                                          Icon(
                                                            Icons.stars,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    154,
                                                                    3),
                                                            size: 20.0,
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              review[items[
                                                                      'clubname']] ??
                                                                  '',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF929292),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'บทบาท :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                'เจ้าของ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          245,
                                                                          70,
                                                                          1),
                                                                  fontSize: 14,
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
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Spacer(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.settings,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      154,
                                                                      3),
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
                                      },
                                    ).toList(),
                                    ...jsonResponse['Admin']
                                        .map<Widget>((adminItem) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        GangOwnerDetail(
                                                  club: adminItem['clubname'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Material(
                                            elevation: 5.0,
                                            shadowColor:
                                                Color.fromARGB(192, 0, 0, 0),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              decoration: ShapeDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFFF5A201)),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          adminItem['clubname'],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .admin_panel_settings,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      154,
                                                                      3),
                                                              size: 20.0,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                adminItem[
                                                                    'owner'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.stars,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      154,
                                                                      3),
                                                              size: 20.0,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                review[adminItem[
                                                                        'clubname']] ??
                                                                    '',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 4),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'บทบาท :',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                'ผู้ดูแล',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          245,
                                                                          70,
                                                                          1),
                                                                  fontSize: 14,
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
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Spacer(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.settings,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      154,
                                                                      3),
                                                              size: 36.0,
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     FloatingActionButton(
                        //       onPressed: () {
                        //         addClubHandle();
                        //         // Navigator.pushReplacement(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //     builder: (BuildContext context) => MyGangOwner(),
                        //         //   ),
                        //         // );
                        //       },
                        //       tooltip: 'สร้างกลุ่ม',
                        //       child: const Icon(Icons.add),
                        //       shape: CircleBorder(), // เปลี่ยนรูปร่างเป็นวงกลม
                        //       elevation: 8,
                        //       backgroundColor: Color(0xFFF5A201),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
