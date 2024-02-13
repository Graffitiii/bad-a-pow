// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GangDetail extends StatefulWidget {
  const GangDetail({super.key});

  @override
  State<GangDetail> createState() => _GangDetailState();
}

class _GangDetailState extends State<GangDetail> {
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
                fontFamily: 'Inter',
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
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
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
                                  fontFamily: 'Inter',
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
                              onPressed: () => {}),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
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
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
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
                              onPressed: () => {}),
                        )),
                  ),
                ],
              ),
            )),
        body: CarouselSliderImage());
  }
}

class CarouselSliderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      left: false,
      right: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              items: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // กำหนดให้เป็นรูปร่างวงกลม
                    image: DecorationImage(
                      image: AssetImage('assets/images/bad1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // กำหนดให้เป็นรูปร่างวงกลม
                    image: DecorationImage(
                      image: AssetImage('assets/images/bad2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/bad3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/bad4.png'),
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
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ก๊วน A',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 20,
                              fontFamily: 'Inter',
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
                                      color: Color(0xFF929292),
                                      offset: Offset(0, -5))
                                ],
                                fontSize: 12,
                                color: Colors.transparent,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF929292),
                                decorationThickness: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.share,
                        color: Color(0xFF515151),
                        size: 22.0,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.10999999940395355),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            '6',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'เข้าร่วมแล้ว',
                            style: TextStyle(
                              color: Color(0xFF929292),
                              fontSize: 13,
                              fontFamily: 'Inter',
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
                            '67',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 20,
                              fontFamily: 'Inter',
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
                              fontFamily: 'Inter',
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
                              fontFamily: 'Inter',
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
                                  fontFamily: 'Inter',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สถานที่',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            Text(
                              'สนามเอสแอนด์เอ็ม',
                              style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 14,
                                fontFamily: 'Inter',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'วัน/เวลา',
                                style: TextStyle(
                                  color: Color(0xFF013C58),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFFAD6),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:
                                        Border.all(color: Color(0xFFFFF17A))),
                                child: Center(
                                    child: Text(
                                  'M',
                                  style: TextStyle(
                                    color: Color(0xFFFFF17A),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE5FFD6),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:
                                        Border.all(color: Color(0xFF8CFF7A))),
                                child: Center(
                                    child: Text(
                                  'W',
                                  style: TextStyle(
                                    color: Color(0xFF8CFF7A),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE3D6FF),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:
                                        Border.all(color: Color(0xFFA47AFF))),
                                child: Center(
                                    child: Text(
                                  'S',
                                  style: TextStyle(
                                    color: Color(0xFFA47AFF),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
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
                              fontFamily: 'Inter',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ติดต่อ',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Text(
                            'โทร 091-717-9662 Line : badminton007',
                            style: TextStyle(
                              color: Color(0xFF929292),
                              fontSize: 14,
                              fontFamily: 'Inter',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ค่าใช้จ่าย',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Text(
                            'ค่าเล่น 75 ค่าลูก 20 ',
                            style: TextStyle(
                              color: Color(0xFF929292),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ลูกแบดที่ใช้',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Text(
                            'Yonex Mavis 350',
                            style: TextStyle(
                              color: Color(0xFF929292),
                              fontSize: 14,
                              fontFamily: 'Inter',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ระดับของผู้เล่น',
                            style: TextStyle(
                              color: Color(0xFF013C58),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFFAD6),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:
                                        Border.all(color: Color(0xFFFFF17A))),
                                child: Center(
                                    child: Text(
                                  'M',
                                  style: TextStyle(
                                    color: Color(0xFFFFF17A),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE5FFD6),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:
                                        Border.all(color: Color(0xFF8CFF7A))),
                                child: Center(
                                    child: Text(
                                  'W',
                                  style: TextStyle(
                                    color: Color(0xFF8CFF7A),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFE3D6FF),
                                    borderRadius: BorderRadius.circular(10.0),
                                    border:
                                        Border.all(color: Color(0xFFA47AFF))),
                                child: Center(
                                    child: Text(
                                  'S',
                                  style: TextStyle(
                                    color: Color(0xFFA47AFF),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                              ),
                            ],
                          )
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              '8 / 10 / 66 มาออกกำลังกายมันส์ๆ ก๊วนลีลาดี จัดโดย พี่อุ๊ย ddddddddddddddddddddddddd ',
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
          ],
        ),
      ),
    ));
  }
}
