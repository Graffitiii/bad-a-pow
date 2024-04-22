import 'package:flutter/material.dart';

class UserLevelScreen extends StatefulWidget {
  const UserLevelScreen({super.key});

  @override
  State<UserLevelScreen> createState() => _UserLevelScreenState();
}

class _UserLevelScreenState extends State<UserLevelScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffe9ecf3), // กำหนดสีพื้นหลังของหน้า
          fontFamily: "Noto"),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "ระดับผู้เล่นของคุณ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          backgroundColor: Color(0xFF00537A),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff), // กำหนดสีพื้นหลังของ Container
                    borderRadius:
                        BorderRadius.circular(15), // Add border radius
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding:
                                        EdgeInsets.fromLTRB(15, 20, 15, 10),
                                    child: Text(
                                      'ระดับของผู้เล่นทั้งหมด',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: Text('ดูทั้งหมด'),
                                  // ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                300, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'NB',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'มือใหม่',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'เคยตีเล่นหน้าบ้าน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ไม่มีประสบการณ์ตีในสนาม',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFCFD8DC),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFF607D8B),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'NB',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF37474F),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "NB"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'newbie มือใหม่ เคยตีเล่นหน้าบ้าน ไม่มีประสบการณ์ตีในสนาม',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                300, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'N-',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'มือใหม่ตีได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีถึงหลัง',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีลูกข้ามเน็ทได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFBBDEFB),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xff2962ff),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'N-',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF0000FF),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "N-"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'มือใหม่ตีได้ ตีถึงหลัง ตีลูกข้ามเน็ทได้',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                345, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'N',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'มือใหม่ตีได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีถึงหลัง',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'หยอดได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      ' ตบได้ ไม่แน่นอน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFB2EBF2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFF26C6DA),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'N',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF00838F),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "N"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'มือใหม่ตีได้ ตีถึงหลัง  หยอดได้ ตบได้ ไม่แน่นอน',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                345, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'S',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'เริ่มเล่นแบด',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีหน้าบ้านมาก่อน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีลูกข้ามเน็ท',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'อยากเรียนรู้ ฝึกฝนเพิ่มเติม',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFCC80),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFFFF9800),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'S',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFE65100),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "S"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'เริ่มเล่นแบด ตีหน้าบ้านมาก่อน ตีลูกข้ามเน็ท อยากเรียนรู้ ฝึกฝนเพิ่มเติม',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                500, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'P-',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'ตีโต้ได้ ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'นับแต้มในเกมได้ ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'มีทักษะบ้างแล้ว ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ท่าทางการตียังไม่เข้าที่ ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'แบคแฮนด์ไม่ได้ ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'วางลูกไม่เป็น',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'รู้ตำแหน่งการยืนบ้าง',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFEDEFF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFFFC7FFF),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'P-',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFFC7FFF),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "P-"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'ตีโต้ได้ นับแต้มในเกมได้ มีทักษะบ้างแล้ว ท่าทางการตียังไม่เข้าที่ แบคแฮนด์ไม่ได้ วางลูกไม่เป็น รู้ตำแหน่งการยืนบ้าง',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                445, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'P',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'ตีโต้ได้ดี ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'วิ่งในเกมส์ได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      ' วางลูกเป็น',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ทักษะเริ่มดี',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'รู้ตำแหน่งยืน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'เริ่มตีได้แบบมาตรฐาน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF8BBD0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xffff63ca),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'P',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xffff63ca),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "P"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'ตีโต้ได้ดี วิ่งในเกมส์ได้ วางลูกเป็น ทักษะเริ่มดี รู้ตำแหน่งยืน เริ่มตีได้แบบมาตรฐาน',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                445, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'P+',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'ตีเป็นเกมส์',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีคุมคนที่อ่อนกว่าได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'เทคนิคดี',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'แบคแฮนด์ได้ดี',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'พลิกแพลงจังหวะ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีลูกไม่ค่อยเสีย',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFE3D6FF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFFA47AFF),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'P+',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFA47AFF),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "P+"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'ตีเป็นเกมส์ ตีคุมคนที่อ่อนกว่าได้ เทคนิคดี แบคแฮนด์ได้ดี พลิกแพลงจังหวะ ตีลูกไม่ค่อยเสีย',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                445, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'C',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'ตีแบดมานาน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'เก๋าเกม',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีเหมือนสั่งได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'เล่นเพื่อแข่งขัน',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'วิ่งคอร์ทดี',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'แก้เกมส์ได้',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0x5B009020),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFF00901F),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'C',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF00901F),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "C"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'ตีแบดมานาน เก๋าเกม ตีเหมือนสั่งได้ เล่นเพื่อแข่งขัน วิ่งคอร์ทดี แก้เกมส์ได้',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width:
                                                150, // Adjust the width as needed
                                            height:
                                                500, // Adjust the height as needed
                                            child: Column(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    'C+',
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  child: Column(children: [
                                                    Text(
                                                      'เด็กฝึก',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ทักษะสูง',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'เบสิกแน่น',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตีลูกไม่พลาด',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'ตบหนัก,อึด,วิ่งได้รอบสนาม',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'มีประสบการณ์สูง แข่งมาเยอะ ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'แข่งมาเยอะ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      child: const Text('ปิด'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(10),
                                    child: Container(
                                      height: 80,
                                      width: double.infinity,
                                      // decoration: ShapeDecoration(
                                      //   color: Color.fromARGB(255, 255, 255, 255),
                                      //   shape: RoundedRectangleBorder(
                                      //     side: BorderSide(
                                      //         width: 2, color: Color(0xFFF5A201)),
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFB2DFDB),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xFF009688),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'C+',
                                                          // items['level'][i],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF00695C),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'ระดับ "C+"',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.55), // Adjust the value as needed
                                                          child: Container(
                                                            child: Text(
                                                              'เด็กฝึก ทักษะสูง เบสิกแน่น ตีลูกไม่พลาด ตบหนัก,อึด,วิ่งได้รอบสนาม มีประสบการณ์สูง แข่งมาเยอะ',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
