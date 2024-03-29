// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:finalmo/postModel.dart';
import 'package:finalmo/screen/edit_event.dart';
import 'package:finalmo/screen/gang/gangOwnerDetail.dart';
import 'package:finalmo/screen/gang/map.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

late String username;
late SharedPreferences prefs;
var myToken;

// bool loading = true;
List<EventList> eventlist = [];
var jsonResponse;
bool status = true;

class GangDetail extends StatefulWidget {
  final id;
  final club;
  const GangDetail({this.id, this.club, super.key});

  @override
  State<GangDetail> createState() => _GangDetailState();
}

class _GangDetailState extends State<GangDetail> {
  var clubInfo = {};
  var userPending;
  var userJoin;
  bool join = false;
  bool pending = false;
  bool openevent = false;
  var eventeach;
  List images = [];
  bool followStatus = false;
  bool loading = true;

  var reviewlist = {};
  var rating = '';

  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    await initSharedPref();
    getEvent(widget.id);
    getReview(widget.club);
  }

  void getEvent(eventId) async {
    var queryParameters = {
      'id': eventId,
    };
    var uri = Uri.http(getUrl, '/getEventDetail', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        eventeach = jsonResponse['data'];
        images = eventeach['image'];
        openevent = eventeach['active'];
        userPending = jsonResponse['data']['pending'];
        userJoin = jsonResponse['data']['join'];
      });

      print("เข้าร่วมแล้ว: $userJoin");
      print("กำลังรอ: $userPending");

      if (eventeach['pending'].contains(username)) {
        print('$username found in the pending.');
        setState(() {
          pending = true;
        });
      } else {
        setState(() {
          pending = false;
        });
      }
      if (eventeach['join'].contains(username)) {
        print('$username found in the pending.');
        setState(() {
          join = true;
        });
      } else {
        setState(() {
          join = false;
        });
      }
      getClubDetail(eventeach['club']);
    } else {}
  }

  void deleteEvent(id) async {
    // print(id);
    var regBody = {"_id": id};

    var response = await http.delete(Uri.parse(delEvent),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      // getTodoList();
    } else {
      print('SDadw');
    }
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
      print("clubInfo:  $clubInfo");

      if (clubInfo['follower'].contains(username)) {
        // print('$username found in the list.');
        setState(() {
          followStatus = true;
        });
      }
      setState(() {
        loading = false;
      });
    }
  }

  void changeStatus() async {
    var regBody = {
      "eventId": eventeach['_id'],
      "status": eventeach['active'],
    };

    var response = await http.put(Uri.parse(putEventStatus),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    // print(regBody);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['edit']) {
      getEvent(eventeach['_id']);
    }
  }

  void onFollow() async {
    var regBody = {"userName": username, "clubId": clubInfo['_id']};

    var response = await http.post(Uri.parse(AddFollow),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print('Follow:');
    print(jsonResponse['status']);
    if (jsonResponse['status']) {
      setState(() {
        followStatus = true;
      });
    }
  }

  void onUnFollow() async {
    var regBody = {"userName": username, "clubId": clubInfo['_id']};

    var response = await http.delete(Uri.parse(unFollow),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print('UnFollow:');
    print(jsonResponse['delete']);
    if (jsonResponse['delete']) {
      setState(() {
        followStatus = false;
      });
    }
  }

  void requestPending() async {
    var regBody = {"userName": username, "event_id": eventeach['_id']};

    var response = await http.post(Uri.parse(sendRequest),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print("กำลังรอเจ้าของตอบรับ");
    if (jsonResponse['status']) {
      setState(() {
        pending = true;
      });
    }
  }

  void unRequestPending() async {
    var regBody = {"userName": username, "event_id": eventeach['_id']};

    var response = await http.delete(Uri.parse(unRequest),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['delete']);
    if (jsonResponse['delete']) {
      setState(() {
        pending = false;
      });
    }
  }

  void acceptJoinEvent(requestuser) async {
    var regBody = {"userName": requestuser, "event_id": eventeach['_id']};

    var response = await http.post(Uri.parse(joinEvent),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print("acceptJoinEvent $jsonResponse");
    // if (jsonResponse['status']) {
    //   setState(() {
    //     initializeState();
    //   });
    // }
  }

  void unacceptJoinEvent(requestuser) async {
    var regBody = {"userName": requestuser, "event_id": eventeach['_id']};

    var response = await http.delete(Uri.parse(unJoinEvent),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    print("เข้าไปแล้ว");
    // if (jsonResponse['delete']) {
    //   setState(() {
    //     join = false;
    //   });
    // }
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
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

    // print(formattedDateTime +
    //     "-" +
    //     formattedEndTime);
    return formattedDateTime + " - " + formattedEndTime;
  }

  void getReview(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getReviewList', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        reviewlist = jsonResponse;
        averageScore(reviewlist);
      });
    }

    setState(() {
      loading = false;
    });
  }

  void averageScore(reviewlist) {
    int sum = 0;
    int count = reviewlist['success'].length;

    for (var value in reviewlist['success']) {
      int score = value['score'];
      sum += score;
    }

    double average = count > 0 ? sum / count : 0;
    String formattedAverage = average.toStringAsFixed(1);
    print('Average Score: $formattedAverage');
    rating = formattedAverage;
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'รายละเอียด',
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
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1.0, color: Color.fromARGB(255, 153, 153, 153)),
              ),
            ),
            height: 70,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Row(
                children: <Widget>[
                  if (clubInfo['owner'] != username) ...[
                    if (!pending && !join) ...[
                      Expanded(
                        flex: 6,
                        child: Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                  child: Text(
                                    'ส่งคำขอเข้าร่วม',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: const Color(0xFF013C58),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => {
                                        setState(() {
                                          requestPending();
                                        }),
                                      }),
                            )),
                      ),
                    ] else if (pending && !join) ...[
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  unRequestPending();
                                });
                              },
                              style: TextButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Color.fromARGB(255, 212, 156,
                                    2), // เปลี่ยนเป็นสีเขียวตามต้องการ
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors
                                        .white, // เปลี่ยนเป็นสีขาวตามต้องการ
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'กำลังรอ',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else if (!pending && join) ...[
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Color(
                                    0xFF02D417), // เปลี่ยนเป็นสีเขียวตามต้องการ
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors
                                        .white, // เปลี่ยนเป็นสีขาวตามต้องการ
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'เข้าร่วมแล้ว',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ] else ...[
                    if (!openevent) ...[
                      Expanded(
                        flex: 5,
                        child: Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                  child: Text(
                                    'เปิดให้เข้าร่วม',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: const Color(0xFFF5A201),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => {
                                        changeStatus()
                                        // setState(() {
                                        //   openevent = true;
                                        // }),
                                      }),
                            )),
                      ),
                    ] else ...[
                      Expanded(
                        flex: 5,
                        child: Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                  child: Text(
                                    'ยกเลิกกิจกรรม',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: const Color(0xFFFF5B5B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => {
                                        changeStatus()
                                        // setState(() {
                                        //   // openevent = false;
                                        //   changeStatus();
                                        // }),
                                      }),
                            )),
                      ),
                    ],
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  'แก้ไข้ข้อมูล',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: const Color(0xFF013C58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EditEvent(id: eventeach)))
                                    }),
                          )),
                    ),
                  ],
                ],
              ),
            )),
        body: SafeArea(
          left: false,
          right: false,
          child: loading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: !status
                      ? Text("Error: ")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Column(children: [
                                  if (images.isNotEmpty) ...[
                                    CarouselSlider(
                                      items: images.map<Widget>((items) {
                                        return Container(
                                          margin: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10), // กำหนดให้เป็นรูปร่างวงกลม
                                            image: DecorationImage(
                                              image: NetworkImage(items),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      options: CarouselOptions(
                                        height: 220.0,
                                        enlargeCenterPage: true,
                                        autoPlay: true,
                                        aspectRatio: 16 / 9,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enableInfiniteScroll: false,
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 1000),
                                        viewportFraction: 0.8,
                                      ),
                                    ),
                                  ] else ...[
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/badapow.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GangOwnerDetail(
                                                                      club: eventeach[
                                                                          'club'])),
                                                        );
                                                      },
                                                      child: Text(
                                                        eventeach['club'],
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          shadows: [
                                                            Shadow(
                                                                color: Color(
                                                                    0xFF013C58),
                                                                offset: Offset(
                                                                    0, -6))
                                                          ],
                                                          color: Colors
                                                              .transparent,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Color(0xFF013C58),
                                                          decorationThickness:
                                                              2,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    if (clubInfo['owner'] !=
                                                        username) ...[
                                                      if (followStatus) ...[
                                                        SizedBox(
                                                          height: 20,
                                                          width: 100,
                                                          child: TextButton(
                                                              // ignore: sort_child_properties_last
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .check,
                                                                      size: 12,
                                                                      color: Color(
                                                                          0xFF02D417),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      'ติดตามแล้ว',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF29C14A),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    )
                                                                  ]),
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      width: 1,
                                                                      color: Color(
                                                                          0xFF29C14A)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                              ),
                                                              onPressed: () => {
                                                                    onUnFollow()
                                                                  }),
                                                        )
                                                      ] else ...[
                                                        SizedBox(
                                                          height: 20,
                                                          child: TextButton(
                                                              child: Text(
                                                                'ติดตาม',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF484848),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  side: BorderSide(
                                                                      width: 1,
                                                                      color: Color(
                                                                          0xFF484848)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                              ),
                                                              onPressed: () =>
                                                                  {onFollow()}),
                                                        )
                                                      ]
                                                    ]
                                                  ],
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            ShareBottton(),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black.withOpacity(
                                                0.10999999940395355),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Spacer(),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      userJoin.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF013C58),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    if (clubInfo['owner'] ==
                                                        username) ...[
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 12),
                                                        color:
                                                            Color(0xFF515151),
                                                        onPressed: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF575757),
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DefaultTabController(
                                                                length: 2,
                                                                child:
                                                                    FractionallySizedBox(
                                                                  heightFactor:
                                                                      0.6,
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              5,
                                                                              10,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          TabBar(
                                                                            tabs: [
                                                                              Tab(
                                                                                child: Text(
                                                                                  "กำลังรอการยืนยัน",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Tab(
                                                                                child: Text(
                                                                                  "เข้าร่วมแล้ว",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TabBarView(
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
                                                                                    child: Column(
                                                                                      children: userPending.map<Widget>((items) {
                                                                                        return Padding(
                                                                                          padding: EdgeInsetsDirectional.all(5),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  CircleAvatar(
                                                                                                    backgroundImage: AssetImage('assets/images/profile1.jpg'),
                                                                                                  ),
                                                                                                  SizedBox(width: 25),
                                                                                                  Text(
                                                                                                    items,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.white,
                                                                                                      fontSize: 14,
                                                                                                      fontWeight: FontWeight.w400,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Spacer(),
                                                                                                  IconButton(
                                                                                                    onPressed: () {
                                                                                                      acceptJoinEvent(items); // ทำการยอมรับข้อมูล
                                                                                                      unacceptJoinEvent(items); // ทำการยกเลิกข้อมูล

                                                                                                      // ลบรายการที่มีค่าเท่ากับ items ออกจาก userPending

                                                                                                      setState(() {
                                                                                                        userPending.removeWhere((item) => item == items);
                                                                                                      });
                                                                                                    },
                                                                                                    icon: Icon(
                                                                                                      Icons.check,
                                                                                                      size: 20,
                                                                                                      color: Colors.green,
                                                                                                    ),
                                                                                                  ),
                                                                                                  IconButton(
                                                                                                    onPressed: () {
                                                                                                      unacceptJoinEvent(items);
                                                                                                      setState(() {
                                                                                                        userPending.removeWhere((item) => item == items);
                                                                                                      });
                                                                                                    },
                                                                                                    icon: Icon(
                                                                                                      Icons.close,
                                                                                                      size: 20,
                                                                                                      color: Colors.red,
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              Container(
                                                                                                width: double.infinity,
                                                                                                height: 1,
                                                                                                color: Colors.black.withOpacity(0.10999999940395355),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      }).toList(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SingleChildScrollView(
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
                                                                                    child: Column(
                                                                                      children: userJoin.map<Widget>((items) {
                                                                                        return Padding(
                                                                                          padding: EdgeInsetsDirectional.all(5),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  CircleAvatar(
                                                                                                    backgroundImage: AssetImage('assets/images/profile1.jpg'),
                                                                                                  ),
                                                                                                  SizedBox(width: 25),
                                                                                                  Text(
                                                                                                    items,
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: 14,
                                                                                                      fontWeight: FontWeight.w400,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Spacer(),
                                                                                                  Text(
                                                                                                    "เข้าร่วมแล้ว",
                                                                                                    style: TextStyle(
                                                                                                      color: Color.fromARGB(255, 26, 255, 26),
                                                                                                      fontSize: 14,
                                                                                                      fontWeight: FontWeight.w400,
                                                                                                    ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 20,
                                                                                              ),
                                                                                              Container(
                                                                                                width: double.infinity,
                                                                                                height: 1,
                                                                                                color: Colors.black.withOpacity(0.10999999940395355),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      }).toList(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                SizedBox(height: 5.0),
                                                Text(
                                                  'เข้าร่วมแล้ว',
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 1,
                                              height: 50,
                                              color: Colors.black.withOpacity(
                                                  0.10999999940395355),
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           ReviewScreen()), // เปลี่ยนเป็นชื่อหน้าหาก๊วนจริงๆ ของคุณ
                                                // );
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    rating,
                                                    style: TextStyle(
                                                      color: Color(0xFF013C58),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'รีวิว',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF929292),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 0,
                                                        ),
                                                      ),
                                                      // Icon(
                                                      //   Icons.arrow_forward_ios,
                                                      //   color:
                                                      //       Color(0xFF929292),
                                                      //   size: 14.0,
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: Color(0x33FF0000),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Color(0xFFFF0000),
                                                    size: 22.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'สถานที่',
                                                    style: TextStyle(
                                                      color: Color(0xFF013C58),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  Text(
                                                    eventeach['placename'],
                                                    style: TextStyle(
                                                      color: Color(0xFF929292),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Spacer(),
                                            IconButton(
                                              iconSize: 20,
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xFF013C58),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MapPage(
                                                              eventLat: eventeach[
                                                                  'latitude'],
                                                              eventLng: eventeach[
                                                                  'longitude'],
                                                              eventPlacename:
                                                                  eventeach[
                                                                      'placename'],
                                                            )));
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: Color(0x3344DC65),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.schedule,
                                                    color: Color(0xFF43DC65),
                                                    size: 22.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'วัน/เวลา',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF013C58),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFFFFFAD6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFFFFF17A))),
                                                      child: Center(
                                                          child: Text(
                                                        'M',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFFFF17A),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 0,
                                                        ),
                                                      )),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFFE5FFD6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFF8CFF7A))),
                                                      child: Center(
                                                          child: Text(
                                                        'W',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF8CFF7A),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 0,
                                                        ),
                                                      )),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFFE3D6FF),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFFA47AFF))),
                                                      child: Center(
                                                          child: Text(
                                                        'S',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFA47AFF),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 0,
                                                        ),
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  formattingDate(
                                                      eventeach[
                                                          'eventdate_start'],
                                                      eventeach[
                                                          'eventdate_end']),
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: Color(0x33CC00FF),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.call,
                                                    color: Color(0xFFCC00FF),
                                                    size: 18.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ติดต่อ',
                                                  style: TextStyle(
                                                    color: Color(0xFF013C58),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                Text(
                                                  eventeach['contact'],
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: Color(0x330028FF),
                                                      shape: BoxShape.circle),
                                                  child: Icon(
                                                    Icons.paid,
                                                    color: Color(0xFF363CC4),
                                                    size: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ค่าใช้จ่าย',
                                                  style: TextStyle(
                                                    color: Color(0xFF013C58),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                Text(
                                                  'ค่าเล่น ' +
                                                      eventeach['priceplay'] +
                                                      ' ค่าลูก ' +
                                                      eventeach[
                                                          'price_badminton'],
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ลูกแบดที่ใช้',
                                                  style: TextStyle(
                                                    color: Color(0xFF013C58),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                Text(
                                                  eventeach['brand'],
                                                  style: TextStyle(
                                                    color: Color(0xFF929292),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ระดับของผู้เล่น',
                                                  style: TextStyle(
                                                    color: Color(0xFF013C58),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                if (eventeach['level'] !=
                                                        null &&
                                                    eventeach['level']
                                                        .isNotEmpty) ...[
                                                  Row(
                                                    children: [
                                                      for (int i = 0;
                                                          i <
                                                              eventeach['level']
                                                                  .length;
                                                          i++)
                                                        Container(
                                                          margin: i > 0
                                                              ? EdgeInsets.only(
                                                                  left: 10)
                                                              : EdgeInsets.zero,
                                                          height: 22,
                                                          width: 22,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: eventeach[
                                                                            'level']
                                                                        [i] ==
                                                                    'N'
                                                                ? Color(
                                                                    0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                : eventeach['level']
                                                                            [
                                                                            i] ==
                                                                        'S'
                                                                    ? Color(
                                                                        0x5B009020)
                                                                    : eventeach['level'][i] ==
                                                                            'P'
                                                                        ? Color(
                                                                            0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                        : Color.fromARGB(
                                                                            255,
                                                                            222,
                                                                            234,
                                                                            255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7), // กำหนด radius ให้กรอบสี่เหลี่ยม
                                                            border: Border.all(
                                                              width: 2,
                                                              color: eventeach[
                                                                              'level']
                                                                          [i] ==
                                                                      'N'
                                                                  ? Color(
                                                                      0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                  : eventeach['level']
                                                                              [
                                                                              i] ==
                                                                          'S'
                                                                      ? Color(
                                                                          0xFF00901F)
                                                                      : eventeach['level'][i] ==
                                                                              'P'
                                                                          ? Color(
                                                                              0xFFFC7FFF)
                                                                          : Color(
                                                                              0xFFFC7FFF),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              eventeach['level']
                                                                  [i],
                                                              style: TextStyle(
                                                                color: eventeach['level']
                                                                            [
                                                                            i] ==
                                                                        'N'
                                                                    ? Color(
                                                                        0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                    : eventeach['level'][i] ==
                                                                            'S'
                                                                        ? Color(
                                                                            0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                        : eventeach['level'][i] ==
                                                                                'P'
                                                                            ? Color(0xFFFC7FFF)
                                                                            : Color(0xFFFC7FFF),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Inter',
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
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'รายละเอียดเพิ่มเติม',
                                                    style: TextStyle(
                                                      color: Color(0xFF013C58),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  Text(
                                                    eventeach['details'],
                                                    style: TextStyle(
                                                      color: Color(0xFF929292),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                  ),
                                ])),
                          ],
                        ),
                ),
        ));
  }
}

class ShareBottton extends StatelessWidget {
  const ShareBottton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share, size: 22),
      color: Color(0xFF515151),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Color(0xFF575757),
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Center(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text(
                      "ก๊วนแมวเหมียว",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/bad4.png",
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.link, size: 22),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                            Text(
                              "คัดลอกลิงค์",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.download, size: 22),
                              color: Colors.white,
                              onPressed: () {},
                            ),
                            Text(
                              "บันทึก QR",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                )),
              ),
            );
          },
        );
      },
    );
  }
}

class RequesttoJoin extends StatelessWidget {
  const RequesttoJoin({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_forward_ios, size: 12),
      color: Color(0xFF515151),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Color(0xFF575757),
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.6,
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 20, 10, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/profile1.jpg'),
                              ),
                              SizedBox(width: 25),
                              Text(
                                "tuna",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.green,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// class TabBarParticipants extends StatefulWidget {
//   final id;
//   const TabBarParticipants({this.id, super.key});

//   @override
//   State<TabBarParticipants> createState() => _TabBarParticipantsState();
// }

// class _TabBarParticipantsState extends State<TabBarParticipants> {

// // Navigator.push(
// //                                                             context,
// //                                                             MaterialPageRoute(
// //                                                               builder: (context) =>
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 1,
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Center(
//             child: Text(
//               'สมาชิกที่ขอเข้าร่วม',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//                 height: 0,
//               ),
//             ),
//           ),
//           backgroundColor: Color(0xFF00537A),
//           bottom: const TabBar(
//             tabs: <Widget>[
//               Tab(
//                 child: Text(
//                   "กำลังรอการยืนยัน",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   "เข้าร่วมแล้ว",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
//                 child: Column(
//                   children: userPending.map<Widget>((items) {
//                     return Padding(
//                       padding: EdgeInsetsDirectional.all(5),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage:
//                                     AssetImage('assets/images/profile1.jpg'),
//                               ),
//                               SizedBox(width: 25),
//                               Text(
//                                 items,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               Spacer(),
//                               IconButton(
//                                 onPressed: () {
//                                   acceptJoinEvent(items); // ทำการยอมรับข้อมูล
//                                   unacceptJoinEvent(items); // ทำการยกเลิกข้อมูล

//                                   // ลบรายการที่มีค่าเท่ากับ items ออกจาก userPending

//                                   setState(() {
//                                     userPending
//                                         .removeWhere((item) => item == items);
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.check,
//                                   size: 20,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   unacceptJoinEvent(items);
//                                   setState(() {
//                                     userPending
//                                         .removeWhere((item) => item == items);
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.close,
//                                   size: 20,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             width: double.infinity,
//                             height: 1,
//                             color:
//                                 Colors.black.withOpacity(0.10999999940395355),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
//                 child: Column(
//                   children: userJoin.map<Widget>((items) {
//                     return Padding(
//                       padding: EdgeInsetsDirectional.all(5),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 backgroundImage:
//                                     AssetImage('assets/images/profile1.jpg'),
//                               ),
//                               SizedBox(width: 25),
//                               Text(
//                                 items,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               Spacer(),
//                               Text(
//                                 "เข้าร่วมแล้ว",
//                                 style: TextStyle(
//                                   color: Color.fromARGB(255, 26, 255, 26),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             width: double.infinity,
//                             height: 1,
//                             color:
//                                 Colors.black.withOpacity(0.10999999940395355),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
