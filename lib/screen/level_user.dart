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
      ),
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
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff), // กำหนดสีพื้นหลังของ Container
                    borderRadius:
                        BorderRadius.circular(15), // Add border radius
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1),
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
                                        EdgeInsets.fromLTRB(15, 20, 15, 20),
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
                                padding: EdgeInsets.all(15),
                                child: GestureDetector(
                                    onTap: () {},
                                    child: Material(
                                        elevation: 5.0,
                                        shadowColor:
                                            Color.fromARGB(192, 0, 0, 0),
                                        borderRadius:
                                            new BorderRadius.circular(30),
                                        child: Container(
                                            height: 100,
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
                                                child: Row(children: [
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          height: 42,
                                                          width: 42,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xFFB2EBF2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              width: 3,
                                                              color: Color(
                                                                  0xFF26C6DA),
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
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          'club',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ])
                                                ]))))),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 1.0),
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  scrollDirection: Axis
                                      .vertical, // กำหนดแนวของ ListView เป็นแนวตั้ง
                                  itemCount: 9, // จำนวนรายการทั้งหมด
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 240.0,
                                      margin: EdgeInsets.only(
                                          right:
                                              10), // กำหนดระยะห่างระหว่างรายการ
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              // leading: Container(
                                              //   margin:
                                              //       EdgeInsets.only(left: 5),
                                              //   height: 42,
                                              //   width: 42,
                                              //   decoration: BoxDecoration(
                                              //     color: Color(0xFFB2EBF2),
                                              //     borderRadius:
                                              //         BorderRadius.circular(10),
                                              //     border: Border.all(
                                              //       width: 3,
                                              //       color: Color(0xFF26C6DA),
                                              //     ),
                                              //   ),
                                              //   child: Center(
                                              //     child: Text(
                                              //       'N',
                                              //       // items['level'][i],
                                              //       style: TextStyle(
                                              //         color: Color(0xFF00838F),
                                              //         fontSize: 18,
                                              //         fontWeight:
                                              //             FontWeight.w700,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              title: Text(
                                                'ระดับ "N"',
                                                style: TextStyle(
                                                  color: Color(0xFF013C58),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  height: 0,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'ระดับ "N"',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
