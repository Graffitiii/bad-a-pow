// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'dart:convert';
import 'package:finalmo/screen/add.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GangOwnerDetail extends StatefulWidget {
  final club;
  const GangOwnerDetail({@required this.club, Key? key}) : super(key: key);

  @override
  State<GangOwnerDetail> createState() => _GangOwnerDetailState();
}

class _GangOwnerDetailState extends State<GangOwnerDetail> {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  bool loading = true;
  var clubInfo = {};
  @override
  void initState() {
    super.initState();
    initSharedPref();
    print(widget.club);
    getClubDetail(widget.club);
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
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
        loading = false;
      });
      print(clubInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "ข้อมูลกลุ่มจัดก๊วน",
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
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: loading
              ? CircularProgressIndicator()
              : Column(children: [
                  Row(
                    children: [
                      Text(
                        clubInfo['clubname'],
                        style: TextStyle(
                          color: Color(0xFF013C58),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height: 30,
                        child: TextButton(
                            child: Text(
                              'ติดตาม',
                              style: TextStyle(
                                color: Color(0xFF484848),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFF484848)),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () => {}),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 230, 179),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.admin_panel_settings,
                              color: Color(0xFFF5A201),
                              size: 18.0,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เจ้าของก๊วน',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Text(
                            clubInfo['owner'],
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
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(0.10999999940395355),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            '64',
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
                        color: Colors.black.withOpacity(0.10999999940395355),
                      ),
                      Spacer(),
                      Column(
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
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF929292),
                                size: 14.0,
                              ),
                            ],
                          )
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),
                  ExpansionTile(
                    title: const Text('เปิดให้เข้าร่วมแล้ว (1)'),
                    textColor: Color(0xFF29C14A),
                    collapsedTextColor: Color(0xFF29C14A),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GangDetail()));
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
                                side: BorderSide(
                                    width: 2, color: Color(0xFFF5A201)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ก๊วน A',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 20,
                                        fontFamily: 'Inter',
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
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
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
                                        Icons.calendar_month,
                                        color: Color(0xFF013C58),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFE3D6FF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFA47AFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'N',
                                              style: TextStyle(
                                                color: Color(0xFFA47AFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0x5B009020),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF00901F)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'P',
                                              style: TextStyle(
                                                color: Color(0xFF00901F),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFFEDEFF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFFC7FFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'S',
                                              style: TextStyle(
                                                color: Color(0xFFFC7FFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Row(children: [
                                      Icon(
                                        Icons.stars,
                                        color: Color.fromARGB(255, 255, 154, 3),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          '4.3',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color:
                                              Color.fromARGB(255, 255, 154, 3),
                                          size: 36.0,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          '4 / 20',
                                          style: TextStyle(
                                            color: Color(0xFF013C58),
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text('ยังไม่เปิดให้เข้าร่วม (3)'),
                    textColor: Color(0xFF929292),
                    collapsedTextColor: Color(0xFF929292),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GangDetail()));
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
                                side: BorderSide(
                                    width: 2, color: Color(0xFFF5A201)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ก๊วน A',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 20,
                                        fontFamily: 'Inter',
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
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
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
                                        Icons.calendar_month,
                                        color: Color(0xFF013C58),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFE3D6FF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFA47AFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'N',
                                              style: TextStyle(
                                                color: Color(0xFFA47AFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0x5B009020),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF00901F)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'P',
                                              style: TextStyle(
                                                color: Color(0xFF00901F),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFFEDEFF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFFC7FFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'S',
                                              style: TextStyle(
                                                color: Color(0xFFFC7FFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Row(children: [
                                      Icon(
                                        Icons.stars,
                                        color: Color.fromARGB(255, 255, 154, 3),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          '4.3',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color:
                                              Color.fromARGB(255, 255, 154, 3),
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
                      SizedBox(
                        height: 10,
                      ),
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GangDetail()));
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
                                side: BorderSide(
                                    width: 2, color: Color(0xFFF5A201)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ก๊วน A',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 20,
                                        fontFamily: 'Inter',
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
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
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
                                        Icons.calendar_month,
                                        color: Color(0xFF013C58),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFE3D6FF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFA47AFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'N',
                                              style: TextStyle(
                                                color: Color(0xFFA47AFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0x5B009020),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF00901F)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'P',
                                              style: TextStyle(
                                                color: Color(0xFF00901F),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFFEDEFF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFFC7FFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'S',
                                              style: TextStyle(
                                                color: Color(0xFFFC7FFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Row(children: [
                                      Icon(
                                        Icons.stars,
                                        color: Color.fromARGB(255, 255, 154, 3),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          '4.3',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color:
                                              Color.fromARGB(255, 255, 154, 3),
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
                      SizedBox(
                        height: 10,
                      ),
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GangDetail()));
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
                                side: BorderSide(
                                    width: 2, color: Color(0xFFF5A201)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ก๊วน A',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 20,
                                        fontFamily: 'Inter',
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
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
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
                                        Icons.calendar_month,
                                        color: Color(0xFF013C58),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFE3D6FF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFA47AFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'N',
                                              style: TextStyle(
                                                color: Color(0xFFA47AFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0x5B009020),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF00901F)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'P',
                                              style: TextStyle(
                                                color: Color(0xFF00901F),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                        Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 22,
                                            width: 22,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFFEDEFF),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Color(0xFFFC7FFF)),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'S',
                                              style: TextStyle(
                                                color: Color(0xFFFC7FFF),
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ))),
                                      ],
                                    ),
                                    SizedBox(height: 7),
                                    Row(children: [
                                      Icon(
                                        Icons.stars,
                                        color: Color.fromARGB(255, 255, 154, 3),
                                        size: 20.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          '4.3',
                                          style: TextStyle(
                                            color: Color(0xFF929292),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color:
                                              Color.fromARGB(255, 255, 154, 3),
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
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Add()))
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Color(0xFF929292),
                            size: 28.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'เพิ่มก๊วน',
                            style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Color(0xFFCFCFCF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ]),
        )),
      ),
    );
  }
}
