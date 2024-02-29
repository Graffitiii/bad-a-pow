// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:finalmo/postModel.dart';
import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/gang/review.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';

bool loading = false;
List<EventList> eventlist = [];
var jsonResponse;
bool status = true;
bool joinevent = true;
bool follow = true;
var eventeach;

class GangDetail extends StatefulWidget {
  final items;
  const GangDetail({@required this.items, Key? key}) : super(key: key);

  @override
  State<GangDetail> createState() => _GangDetailState();
}

class _GangDetailState extends State<GangDetail> {
  void initState() {
    // TODO: implement initState
    // print(widget.items);
    eventeach = widget.items;
    print(eventeach);
    print(joinevent);
    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // userId = jwtDecodedToken['_id'];
  }

  void deleteEvent(id) async {
    print(id);
    var regBody = {"_id": id};

    var response = await http.delete(Uri.parse(delEventData),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      // getTodoList();
    } else {
      print('SDadw');
    }
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
                  if (follow) ...[
                    Expanded(
                      flex: 4,
                      child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  'ติดตาม',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2, color: Color(0xFF4C5B63)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => {
                                      setState(() {
                                        follow = false;
                                      }),
                                    }),
                          )),
                    ),
                  ] else ...[
                    Expanded(
                      flex: 4,
                      child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  'กำลังติดตาม',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2, color: Color(0xFF4C5B63)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => {
                                      setState(() {
                                        follow = true;
                                      }),
                                    }),
                          )),
                    ),
                  ],
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  if (joinevent) ...[
                    Expanded(
                      flex: 6,
                      child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                                child: Text(
                                  'เข้าร่วม',
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
                                        joinevent = false;
                                      }),
                                    }),
                          )),
                    ),
                  ] else ...[
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
                                joinevent = true;
                              });
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
                ],
              ),
            )),
        body: CarouselSliderImage());
  }
}

class CarouselSliderImage extends StatefulWidget {
  const CarouselSliderImage({super.key});

  @override
  State<CarouselSliderImage> createState() => _CarouselSliderImageState();
}

class _CarouselSliderImageState extends State<CarouselSliderImage> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   getTodoList();
  //   super.initState();
  //   // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
  //   // userId = jwtDecodedToken['_id'];
  // }

  // void getTodoList() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   var response = await http.get(
  //     Uri.parse(getToDoList),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     jsonResponse = jsonDecode(response.body);

  //     jsonResponse['clublistdata'].forEach((value) => eventlist.add(EventList(
  //           club: value['club'],
  //           contact: value['contact'],
  //           priceBadminton: value['price_badminton'],
  //           priceplay: value['priceplay'],
  //           level: value['level'],
  //           brand: value['brand'],
  //           details: value['details'],
  //         )));
  //     status = true;

  //     print(jsonResponse);
  //     // print(jsonResponse.eventlist.toString());
  //   } else {
  //     status = true;

  //     print(response.statusCode);
  //   }
  //   // items = jsonResponse['clublistdata'];
  //   // List<EventList> eventlist = [],

  //   // print(jsonResponse);
  //   loading = false;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              CarouselSlider(
                                items: [
                                  Container(
                                    margin: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          10), // กำหนดให้เป็นรูปร่างวงกลม
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bad1.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          10), // กำหนดให้เป็นรูปร่างวงกลม
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bad2.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bad3.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bad4.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                                options: CarouselOptions(
                                  height: 220.0,
                                  enlargeCenterPage: true,
                                  autoPlay: false,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  viewportFraction: 0.8,
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              eventeach['club'],
                                              style: TextStyle(
                                                color: Color(0xFF013C58),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                                "Tamonwan Pro",
                                                style: TextStyle(
                                                  shadows: [
                                                    Shadow(
                                                        color:
                                                            Color(0xFF929292),
                                                        offset: Offset(0, -5))
                                                  ],
                                                  fontSize: 12,
                                                  color: Colors.transparent,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Color(0xFF929292),
                                                  decorationThickness: 1,
                                                ),
                                              ),
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
                                        color: Colors.black
                                            .withOpacity(0.10999999940395355),
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
                                                  '6',
                                                  style: TextStyle(
                                                    color: Color(0xFF013C58),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0,
                                                  ),
                                                ),
                                                RequesttoJoin(),
                                              ],
                                            ),
                                            SizedBox(height: 5),
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
                                          color: Colors.black
                                              .withOpacity(0.10999999940395355),
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                              '67',
                                              style: TextStyle(
                                                color: Color(0xFF013C58),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'ผู้ติดตาม',
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
                                          color: Colors.black
                                              .withOpacity(0.10999999940395355),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReviewScreen()), // เปลี่ยนเป็นชื่อหน้าหาก๊วนจริงๆ ของคุณ
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                '4.6',
                                                style: TextStyle(
                                                  color: Color(0xFF013C58),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  height: 0,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text(
                                                    'รีวิว',
                                                    style: TextStyle(
                                                      color: Color(0xFF929292),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Color(0xFF929292),
                                                    size: 14.0,
                                                  ),
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
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'สถานที่',
                                                style: TextStyle(
                                                  color: Color(0xFF013C58),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              Text(
                                                'สนามเอสแอนด์เอ็ม',
                                                style: TextStyle(
                                                  color: Color(0xFF929292),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF013C58),
                                          size: 22.0,
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
                                                    color: Color(0xFF013C58),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFFFAD6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFFFF17A))),
                                                  child: Center(
                                                      child: Text(
                                                    'M',
                                                    style: TextStyle(
                                                      color: Color(0xFFFFF17A),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  )),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFE5FFD6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFF8CFF7A))),
                                                  child: Center(
                                                      child: Text(
                                                    'W',
                                                    style: TextStyle(
                                                      color: Color(0xFF8CFF7A),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  )),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFE3D6FF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFA47AFF))),
                                                  child: Center(
                                                      child: Text(
                                                    'S',
                                                    style: TextStyle(
                                                      color: Color(0xFFA47AFF),
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
                                              'วันจันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
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
                                                  eventeach['price_badminton'],
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
                                            if (eventeach['level'] != null &&
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
                                                      decoration: BoxDecoration(
                                                        color: eventeach[
                                                                        'level']
                                                                    [i] ==
                                                                'N'
                                                            ? Color(
                                                                0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                            : eventeach['level']
                                                                        [i] ==
                                                                    'S'
                                                                ? Color(
                                                                    0x5B009020)
                                                                : eventeach['level']
                                                                            [
                                                                            i] ==
                                                                        'P'
                                                                    ? Color(
                                                                        0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                    : Color
                                                                        .fromARGB(
                                                                            255,
                                                                            222,
                                                                            234,
                                                                            255),
                                                        borderRadius:
                                                            BorderRadius.circular(
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
                                                                          [i] ==
                                                                      'S'
                                                                  ? Color(
                                                                      0xFF00901F)
                                                                  : eventeach['level']
                                                                              [
                                                                              i] ==
                                                                          'P'
                                                                      ? Color(
                                                                          0xFFFC7FFF)
                                                                      : Color(
                                                                          0xFFFC7FFF),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          eventeach['level'][i],
                                                          style: TextStyle(
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
                                                                        0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                    : eventeach['level'][i] ==
                                                                            'P'
                                                                        ? Color(
                                                                            0xFFFC7FFF)
                                                                        : Color(
                                                                            0xFFFC7FFF),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              Text(
                                                eventeach['details'],
                                                style: TextStyle(
                                                  color: Color(0xFF929292),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
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
              heightFactor: 0.6,
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
