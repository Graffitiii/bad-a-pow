// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:finalmo/screen/add.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
final List<String> level = [
  'N',
  'S',
  'P',
];
List<String> selectedlevel = [];

final List<String> time = [
  '17.00 - 18.00',
  '18.00 - 19.00',
  '19.00 - 20.00',
];
List<String> selectedtime = [];

class FindGang extends StatefulWidget {
  const FindGang({super.key});

  @override
  State<FindGang> createState() => _FindGangState();
}

class _FindGangState extends State<FindGang> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',

  //   ),
  //   Text(
  //     'Index 1: Business',

  //   ),
  //   Text(
  //     'Index 2: School',

  //   ),
  //   Text(
  //     'Index 3: Settings',

  //   ),
  // ];

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
              "หาก๊วน",
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'หาก๊วน',
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.home_rounded,
                size: 35,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'ก๊วนของฉัน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'โปรไฟล์',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.black.withOpacity(0.3100000023841858),
          showUnselectedLabels: true,
          unselectedLabelStyle:
              TextStyle(color: Colors.black.withOpacity(0.3100000023841858)),
          onTap: _onItemTapped,
        ),
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Container(
                  child: Column(
                children: [
                  Row(children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xFFFF3333),
                      size: 30.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'ที่อยู่ :',
                        style: TextStyle(
                          color: Color(0xFFFF3333),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'อาคารเรียนรวม 2',
                        style: TextStyle(
                          color: Color(0xFF00537A),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Spacer(),
                    // new GestureDetector( // I just added one line
                    Container(
                        height: 30,
                        width: 30,
                        decoration: ShapeDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(width: 2, color: Color(0xFF013C58)),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.tune,
                            color: Color(0xFF013C58),
                            size: 22.0,
                          ),
                        )),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  Material(
                    elevation: 5.0,
                    shadowColor: Color.fromARGB(255, 0, 0, 0),
                    borderRadius: new BorderRadius.circular(30),
                    child: TextFormField(
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
                        // labelText: 'วัน',
                        // labelStyle: TextStyle(
                        //   color: Colors.black
                        //       .withOpacity(0.3100000023841858),
                        //   fontSize: 14,
                        //   fontFamily: 'Inter',
                        //   fontWeight: FontWeight.w400,
                        // ),
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
                  SizedBox(
                    height: 20,
                  ),
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Add()));
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
                            side:
                                BorderSide(width: 2, color: Color(0xFFF5A201)),
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
                                      color: Color.fromARGB(255, 255, 154, 3),
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
                  SizedBox(height: 15),
                  Material(
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
                                'ก๊วน B',
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
                  )
                ],
              ))),
        ));
  }
}
