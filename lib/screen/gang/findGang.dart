// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:finalmo/postModel.dart';
import 'package:finalmo/screen/gang/filter_gang.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';

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
  List<EventList> eventlist = [];
  var jsonResponse;
  bool status = false;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    getTodoList();
    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // userId = jwtDecodedToken['_id'];
  }

  void getTodoList() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(
      Uri.parse(getEventList),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);

      jsonResponse['eventlistdata'].forEach((value) => eventlist.add(EventList(
            club: value['club'],
            contact: value['contact'],
            priceBadminton: value['price_badminton'],
            priceplay: value['priceplay'],
            level: value['level'],
            brand: value['brand'],
            details: value['details'],
          )));
      status = true;

      print(jsonResponse);
      // print(jsonResponse.eventlist.toString());
    } else {
      status = true;

      print(response.statusCode);
    }
    // items = jsonResponse['clublistdata'];
    // List<EventList> eventlist = [],

    // print(jsonResponse);
    loading = false;
    setState(() {});
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
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(0),
          child: loading
              ? CircularProgressIndicator()
              :
              //if loading == true, show progress indicator
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                          Filter(),
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
                              fillColor: Color(0xFFF4F4F4),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              border: InputBorder.none,
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.0, color: Colors.red),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1.0, color: Colors.red),
                              ),
                              errorStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          //if there is any error, show error message
                          child: !status
                              ? Text("Error: ")
                              : Column(
                                  //if everything fine, show the JSON as widget
                                  children: jsonResponse['eventlistdata']
                                      .map<Widget>((items) {
                                    return Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        GangDetail(
                                                            id: items['_id'])));
                                            // if (items != null) {
                                            //   // ตรวจสอบว่า items ไม่เป็น null ก่อน

                                            // }
                                            // print(items);
                                          },
                                          child: Material(
                                            elevation: 5.0,
                                            shadowColor:
                                                Color.fromARGB(192, 0, 0, 0),
                                            borderRadius:
                                                new BorderRadius.circular(30),
                                            child: Container(
                                              height: 160,
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
                                                          items['club'],
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF013C58),
                                                            fontSize: 20,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.location_on,
                                                              color: Color(
                                                                  0xFFFF3333),
                                                              size: 20.0,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                'สนามเอสแอนด์เอ็ม จรัญ13 (12 กม.)',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              color: Color(
                                                                  0xFF013C58),
                                                              size: 20.0,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        if (items['level'] !=
                                                                null &&
                                                            items['level']
                                                                .isNotEmpty) ...[
                                                          Row(
                                                            children: [
                                                              for (int i = 0;
                                                                  i <
                                                                      items['level']
                                                                          .length;
                                                                  i++)
                                                                Container(
                                                                  margin: i > 0
                                                                      ? EdgeInsets.only(
                                                                          left:
                                                                              10)
                                                                      : EdgeInsets
                                                                          .zero,
                                                                  height: 22,
                                                                  width: 22,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: items['level'][i] ==
                                                                            'N'
                                                                        ? Color(
                                                                            0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                        : items['level'][i] ==
                                                                                'S'
                                                                            ? Color(0x5B009020)
                                                                            : items['level'][i] == 'P'
                                                                                ? Color(0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                                : Color.fromARGB(255, 222, 234, 255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            7), // กำหนด radius ให้กรอบสี่เหลี่ยม
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      width: 2,
                                                                      color: items['level'][i] ==
                                                                              'N'
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
                                                                      items['level']
                                                                          [i],
                                                                      style:
                                                                          TextStyle(
                                                                        color: items['level'][i] ==
                                                                                'N'
                                                                            ? Color(0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                            : items['level'][i] == 'S'
                                                                                ? Color(0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                                : items['level'][i] == 'P'
                                                                                    ? Color(0xFFFC7FFF)
                                                                                    : Color(0xFFFC7FFF),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'Inter',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        height:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                        SizedBox(height: 7),
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
                                                              '4.3',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF929292),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                                              Icons
                                                                  .arrow_forward_ios,
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
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '4 / 20',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF013C58),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 0,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                    // Card(
                                    //   child: ListTile(
                                    //     title: Text(country['club']),
                                    //     subtitle: Text(country['contact']),
                                    //   ),
                                    // )
                                  }).toList(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
// Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: eventlist == null
//               ? null
//               : ListView.builder(
//                   itemCount: eventlist.length,
//                   itemBuilder: (context, int index) {
//                     return Card(
//                       borderOnForeground: false,
//                       child: ListTile(
//                         leading: Icon(Icons.task),
//                         title: Text('${eventlist[index].club}'),
//                         subtitle: Text('${eventlist[index].contact}'),
//                         trailing: Icon(Icons.arrow_back),
//                       ),
//                     );
//                   }),
//         ),
//       ),

