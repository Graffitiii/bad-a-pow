// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'package:finalmo/screen/calender.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/material.dart';

class MyGangJoin extends StatefulWidget {
  const MyGangJoin({super.key});

  @override
  State<MyGangJoin> createState() => _MyGangJoinState();
}

class _MyGangJoinState extends State<MyGangJoin> {
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
          children: [
            new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => GangDetail()));
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ก๊วน Aa',
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
                                          width: 2, color: Color(0xFFA47AFF)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'N',
                                    style: TextStyle(
                                      color: Color(0xFFA47AFF),
                                      fontSize: 12,
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
                                          width: 2, color: Color(0xFF00901F)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'P',
                                    style: TextStyle(
                                      color: Color(0xFF00901F),
                                      fontSize: 12,
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
                                          width: 2, color: Color(0xFFFC7FFF)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'S',
                                    style: TextStyle(
                                      color: Color(0xFFFC7FFF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ))),
                            ],
                          ),
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
            SizedBox(height: 15),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => GangDetail()));
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ก๊วน A',
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
                                          width: 2, color: Color(0xFFA47AFF)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'N',
                                    style: TextStyle(
                                      color: Color(0xFFA47AFF),
                                      fontSize: 12,
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
                                          width: 2, color: Color(0xFF00901F)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'P',
                                    style: TextStyle(
                                      color: Color(0xFF00901F),
                                      fontSize: 12,
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
                                          width: 2, color: Color(0xFFFC7FFF)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'S',
                                    style: TextStyle(
                                      color: Color(0xFFFC7FFF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ))),
                            ],
                          ),
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
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                'เข้าร่วมแล้ว',
                                style: TextStyle(
                                  color: Color(0xFF43DC65),
                                  fontSize: 14,
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
            SizedBox(height: 15),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => GangDetail()));
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ก๊วน A',
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
                                          width: 2, color: Color(0xFFA47AFF)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'N',
                                    style: TextStyle(
                                      color: Color(0xFFA47AFF),
                                      fontSize: 12,
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
                                          width: 2, color: Color(0xFF00901F)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'P',
                                    style: TextStyle(
                                      color: Color(0xFF00901F),
                                      fontSize: 12,
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
                                          width: 2, color: Color(0xFFFC7FFF)),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'S',
                                    style: TextStyle(
                                      color: Color(0xFFFC7FFF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ))),
                            ],
                          ),
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
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(
                                  color: Color(0xFFFF0000),
                                  fontSize: 14,
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
          ],
        ),
      ],
    );
  }
}
