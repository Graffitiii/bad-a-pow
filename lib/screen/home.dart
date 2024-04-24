// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:finalmo/config.dart';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/calender.dart';
import 'package:finalmo/screen/level_user.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:finalmo/screen/profile/history_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final token;
  const HomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  TextEditingController eventtime = TextEditingController();
  TextEditingController eventdate = TextEditingController();
  String afterEventtime = '';
  String afterEventdate = '';
  String formattedStartTime = '';
  String formattedEndTime = '';
  late Set<String> _selectedValues = {};

  final _formKey = GlobalKey<FormState>();
  String username = '';
  var myToken;
  late SharedPreferences prefs;
  var clubInfo;
  var historyData;
  bool loadingHis = true;

  @override
  void initState() {
    initializeState();
    super.initState();
    // print(JwtDecoder.getRemainingTime(widget.token));
  }

  void initializeState() async {
    await initSharedPref();
    getHistory();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);

    setState(() {
      username = jwtDecodedToken['userName'];
    });
  }

  void getHistory() async {
    var queryParameters = {'username': username, 'limit': '3'};

    var uri = Uri.http(getUrl, '/findHistory', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        historyData = jsonResponse['result'];
      });

      print(historyData);
      setState(() {
        loadingHis = false;
      });
    }
  }

  Future<TimeOfDay?> getTime({
    required BuildContext context,
    String? title,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "ยกเลิก",
      confirmText: confirmText ?? "บันทึก",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    return time;
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }

  String formatDate(String date) {
    List<String> dateParts = date.split('/');
    String formattedDate =
        '${dateParts[2]}-${_addLeadingZero(int.parse(dateParts[0]))}-${_addLeadingZero(int.parse(dateParts[1]))}';

    // เพิ่มโค้ดในการแปลงเวลาตามต้องการ

    return '$formattedDate';
  }

  String formatTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    // print("$hour:$minute");
    return '$hour:$minute';
  }

  String formatNewTime(String time) {
    List<String> timeParts = time.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // ลบ 7 ชั่วโมง
    hour -= 7;

    // แปลงค่าลูกน้ำต้องการให้เป็นตัวเลขบวก
    if (hour < 0) {
      hour += 24; // 24 ชั่วโมงในวัน
    }

    String formattedTime =
        '${_addLeadingZero(hour)}:${_addLeadingZero(minute)}:00.000Z';
    return '$formattedTime';
  }

  String formattingDate(start, end) {
    initializeDateFormatting('th', null);

    DateTime eventStart = DateTime.parse(start);
    DateTime eventEnd = DateTime.parse(end);
    // print(eventStart);
    DateTime thaiDateStartTime = eventStart.add(Duration(hours: 7));
    DateTime thaiDateEndTime = eventEnd.add(Duration(hours: 7));

    String formattedDateTime =
        DateFormat('d MMMM H:mm', 'th').format(thaiDateStartTime);

    String formattedEndTime =
        DateFormat('H:mm น.', 'th').format(thaiDateEndTime);

    // print(formattedDateTime + "-" + formattedEndTime);
    return formattedDateTime + " - " + formattedEndTime;
  }

  void updatefilter(String newDate) {
    setState(() {
      afterEventdate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "หน้าหลัก",
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      stops: [0.1, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF013C58), Color(0xFF0074AB)],
                    )),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 10, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ยินดีต้อนรับ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        SizedBox(height: 10),
                        Opacity(
                          opacity: 0.80,
                          child: Container(
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'สถานะ : Owner',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )),
                            // width: 87,
                            // height: 17,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 13,
                                child: Material(
                                  elevation: 5.0,
                                  shadowColor: Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: new BorderRadius.circular(30),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      print(search.text);
                                    },
                                    controller: search,
                                    decoration: InputDecoration(
                                      // suffixIcon: IconButton(
                                      //   icon: Icon(
                                      //     Icons.tune,
                                      //   ),
                                      //   color:
                                      //       Color.fromARGB(255, 100, 100, 100),
                                      //   onPressed: () {
                                      //     showModalBottomSheet(
                                      //       context: context,
                                      //       isScrollControlled: true,
                                      //       builder: (BuildContext context) {
                                      //         return StatefulBuilder(builder:
                                      //             (BuildContext context,
                                      //                 StateSetter setState) {
                                      //           return FractionallySizedBox(
                                      //             heightFactor: 0.5,
                                      //             child: Container(
                                      //               child: Form(
                                      //                 key: _formKey,
                                      //                 child:
                                      //                     SingleChildScrollView(
                                      //                   child: Column(
                                      //                     mainAxisAlignment:
                                      //                         MainAxisAlignment
                                      //                             .start,
                                      //                     children: [
                                      //                       SizedBox(
                                      //                         height: 30,
                                      //                       ),
                                      //                       Padding(
                                      //                         padding: EdgeInsets
                                      //                             .symmetric(
                                      //                                 vertical:
                                      //                                     0,
                                      //                                 horizontal:
                                      //                                     20),
                                      //                         child: Row(
                                      //                           children: [
                                      //                             Text(
                                      //                               'วันที่ต้องการเข้าร่วม',
                                      //                               style:
                                      //                                   TextStyle(
                                      //                                 color: Colors
                                      //                                     .black,
                                      //                                 fontSize:
                                      //                                     16,
                                      //                                 fontWeight:
                                      //                                     FontWeight
                                      //                                         .w400,
                                      //                                 height: 0,
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       // ChipDateWeek(),
                                      //                       Row(
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .start,
                                      //                           children: [
                                      //                             Padding(
                                      //                               padding: const EdgeInsets
                                      //                                   .symmetric(
                                      //                                   horizontal:
                                      //                                       20,
                                      //                                   vertical:
                                      //                                       10),
                                      //                               child:
                                      //                                   Container(
                                      //                                 width:
                                      //                                     370,
                                      //                                 height:
                                      //                                     50,
                                      //                                 child:
                                      //                                     Container(
                                      //                                   decoration:
                                      //                                       BoxDecoration(
                                      //                                     boxShadow: [
                                      //                                       BoxShadow(
                                      //                                         color: Color(0x3F000000),
                                      //                                         blurRadius: 4,
                                      //                                         offset: Offset(0, 4),
                                      //                                         spreadRadius: 0,
                                      //                                       ),
                                      //                                     ],
                                      //                                     borderRadius:
                                      //                                         BorderRadius.circular(5.0),
                                      //                                     color:
                                      //                                         Color(0xFFEFEFEF),
                                      //                                   ),
                                      //                                   child:
                                      //                                       Padding(
                                      //                                     padding: EdgeInsets.symmetric(
                                      //                                         vertical: 0,
                                      //                                         horizontal: 0),
                                      //                                     child:
                                      //                                         TextField(
                                      //                                       controller:
                                      //                                           eventdate,
                                      //                                       decoration:
                                      //                                           InputDecoration(
                                      //                                         labelText: "เลือกวันที่*",
                                      //                                         labelStyle: TextStyle(
                                      //                                           color: Colors.black.withOpacity(0.3100000023841858),
                                      //                                           fontSize: 14,
                                      //                                           fontWeight: FontWeight.w400,
                                      //                                         ),
                                      //                                         focusedBorder: OutlineInputBorder(
                                      //                                           borderSide: BorderSide(width: 1.0),
                                      //                                         ),
                                      //                                         enabledBorder: OutlineInputBorder(
                                      //                                           borderSide: BorderSide.none,
                                      //                                           borderRadius: BorderRadius.circular(5.0),
                                      //                                         ),
                                      //                                         border: InputBorder.none,
                                      //                                         filled: true,
                                      //                                         fillColor: Color(0xFFEFEFEF),
                                      //                                         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                      //                                       ),
                                      //                                       readOnly:
                                      //                                           true,
                                      //                                       onTap:
                                      //                                           () async {
                                      //                                         DateTime? pickedDate = await showDatePicker(
                                      //                                           context: context,
                                      //                                           initialDate: DateTime.now(),
                                      //                                           firstDate: DateTime(2000),
                                      //                                           lastDate: DateTime(2101),
                                      //                                         );
                                      //                                         if (pickedDate != null) {
                                      //                                           String formattedDate = DateFormat.yMd().format(pickedDate);
                                      //                                           eventdate.text = formattedDate.toString();

                                      //                                           setState(() {
                                      //                                             afterEventdate = formatDate(eventdate.text);
                                      //                                             print("newdate: " + afterEventdate);
                                      //                                           });
                                      //                                         } else {
                                      //                                           print("Not selected");
                                      //                                         }
                                      //                                       },
                                      //                                     ),
                                      //                                   ),
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                           ]),
                                      //                       Column(
                                      //                         crossAxisAlignment:
                                      //                             CrossAxisAlignment
                                      //                                 .start,
                                      //                         children: [
                                      //                           Padding(
                                      //                             padding: EdgeInsets
                                      //                                 .symmetric(
                                      //                                     vertical:
                                      //                                         0,
                                      //                                     horizontal:
                                      //                                         20),
                                      //                             child: Row(
                                      //                               children: [
                                      //                                 Text(
                                      //                                   "เวลาเริ่ม",
                                      //                                   style:
                                      //                                       TextStyle(
                                      //                                     color:
                                      //                                         Colors.black,
                                      //                                     fontSize:
                                      //                                         16,
                                      //                                     fontWeight:
                                      //                                         FontWeight.w400,
                                      //                                     height:
                                      //                                         0,
                                      //                                   ),
                                      //                                 ),
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                           Padding(
                                      //                             padding: EdgeInsets.symmetric(
                                      //                                 horizontal:
                                      //                                     20,
                                      //                                 vertical:
                                      //                                     10),
                                      //                             child: Row(
                                      //                               children: [
                                      //                                 Expanded(
                                      //                                   child:
                                      //                                       FractionallySizedBox(
                                      //                                     child:
                                      //                                         GestureDetector(
                                      //                                       onTap:
                                      //                                           () async {
                                      //                                         TimeOfDay? time = await getTime(
                                      //                                           context: context,
                                      //                                           title: "เลือกเวลาเริ่มกิจกรรม",
                                      //                                         );
                                      //                                         if (time != null) {
                                      //                                           String formattedTime = formatTime(time);
                                      //                                           eventtime.text = formattedTime;
                                      //                                           // print("formattedTime" + formattedTime);
                                      //                                           print(eventtime.text);

                                      //                                           setState(() {
                                      //                                             afterEventtime = formatNewTime(eventtime.text);
                                      //                                             print("newtime: " + afterEventtime);
                                      //                                           });
                                      //                                         }
                                      //                                       },
                                      //                                       child:
                                      //                                           Container(
                                      //                                         decoration: _buildBoxUser(),
                                      //                                         child: Center(
                                      //                                           child: TextFormField(
                                      //                                             controller: eventtime,
                                      //                                             enabled: false,
                                      //                                             enableInteractiveSelection: true,
                                      //                                             decoration: InputDecoration(
                                      //                                               hintText: 'เลือกเวลา*',
                                      //                                               border: InputBorder.none,
                                      //                                               contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                      //                                             ),
                                      //                                           ),
                                      //                                         ),
                                      //                                       ),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ),
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                           Padding(
                                      //                             padding: EdgeInsets
                                      //                                 .symmetric(
                                      //                                     vertical:
                                      //                                         0,
                                      //                                     horizontal:
                                      //                                         20),
                                      //                             child: Row(
                                      //                               children: [
                                      //                                 Text(
                                      //                                   'ระดับของผู้เล่น',
                                      //                                   style:
                                      //                                       TextStyle(
                                      //                                     color:
                                      //                                         Colors.black,
                                      //                                     fontSize:
                                      //                                         16,
                                      //                                     fontWeight:
                                      //                                         FontWeight.w400,
                                      //                                     height:
                                      //                                         0,
                                      //                                   ),
                                      //                                 ),
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                           ChipLevel(
                                      //                               onChanged:
                                      //                                   (values) {
                                      //                                 // Update the selected values in Filter
                                      //                                 setState(
                                      //                                     () {
                                      //                                   _selectedValues =
                                      //                                       values;
                                      //                                 });
                                      //                                 // Print the selected values in Filter
                                      //                                 print(
                                      //                                     _selectedValues);
                                      //                               },
                                      //                               select:
                                      //                                   _selectedValues),
                                      //                           Padding(
                                      //                             padding: EdgeInsets.symmetric(
                                      //                                 vertical:
                                      //                                     15,
                                      //                                 horizontal:
                                      //                                     30),
                                      //                             child: Row(
                                      //                               children: [
                                      //                                 Expanded(
                                      //                                   child:
                                      //                                       FractionallySizedBox(
                                      //                                     child:
                                      //                                         ElevatedButton(
                                      //                                       onPressed:
                                      //                                           () {
                                      //                                         // distance
                                      //                                         //     .clear();
                                      //                                         // eventtime
                                      //                                         //     .clear();
                                      //                                         // eventdate
                                      //                                         //     .clear();
                                      //                                         // _selectedValues
                                      //                                         //     .clear();
                                      //                                         // print(
                                      //                                         //     _selectedValues);
                                      //                                       },
                                      //                                       style:
                                      //                                           ElevatedButton.styleFrom(
                                      //                                         primary: Color(0xFFEFEFEF), // สีพื้นหลังของปุ่ม
                                      //                                         shape: RoundedRectangleBorder(
                                      //                                           borderRadius: BorderRadius.circular(10), // รูปทรงของปุ่ม
                                      //                                         ),
                                      //                                       ),
                                      //                                       child:
                                      //                                           Text(
                                      //                                         'ล้าง',
                                      //                                         style: TextStyle(
                                      //                                           color: Color(0xFF013C58), // สีของตัวอักษรในปุ่ม
                                      //                                           fontSize: 16,
                                      //                                           fontWeight: FontWeight.w600,
                                      //                                         ),
                                      //                                       ),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ),
                                      //                                 SizedBox(
                                      //                                     width:
                                      //                                         10),
                                      //                                 Expanded(
                                      //                                   child:
                                      //                                       FractionallySizedBox(
                                      //                                     child:
                                      //                                         ElevatedButton(
                                      //                                       onPressed:
                                      //                                           () async {
                                      //                                         // if location change
                                      //                                         updatefilter(afterEventdate);
                                      //                                         Navigator.of(context).pop();

                                      //                                         // print(eventtime.text);

                                      //                                         // print(
                                      //                                         //     placename);

                                      //                                         // Navigator.pop(context, placename);
                                      //                                       },
                                      //                                       style:
                                      //                                           ElevatedButton.styleFrom(
                                      //                                         primary: Color(0xFF013C58), // สีพื้นหลังของปุ่ม
                                      //                                         shape: RoundedRectangleBorder(
                                      //                                           borderRadius: BorderRadius.circular(10), // รูปทรงของปุ่ม
                                      //                                         ),
                                      //                                       ),
                                      //                                       child:
                                      //                                           Text(
                                      //                                         'บันทึก',
                                      //                                         style: TextStyle(
                                      //                                           color: Colors.white, // สีของตัวอักษรในปุ่ม
                                      //                                           fontSize: 16,
                                      //                                           fontWeight: FontWeight.w600,
                                      //                                         ),
                                      //                                       ),
                                      //                                     ),
                                      //                                   ),
                                      //                                 ),
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           );
                                      //         });
                                      //       },
                                      //     );
                                      //   },
                                      // ),

                                      hintText: 'ค้นหากิจกรรม',
                                      // prefixIcon: Padding(
                                      //   padding: EdgeInsets.only(left: 15),
                                      //   child: Icon(Icons.search),
                                      // ),
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
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.red),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.red),
                                      ),
                                      errorStyle: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                  flex: 2,
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 227, 239, 245),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      iconSize: 30,
                                      icon: Icon(
                                        Icons.search,
                                      ),
                                      color: Color(0xFF00537A),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TabBarViewFindEvent(
                                                    search: search.text,
                                                  )),
                                        );
                                      },
                                    ),
                                  ))
                            ],
                          )),
                      // if (afterEventdate != '') ...[
                      //   Row(
                      //     children: [
                      //       InputChip(
                      //         onPressed: () {},
                      //         onDeleted: () {
                      //           setState(() {
                      //             afterEventdate = '';
                      //           });
                      //         },
                      //         avatar: const Icon(
                      //           Icons.date_range_outlined,
                      //           size: 20,
                      //           color: Colors.black54,
                      //         ),
                      //         deleteIconColor: Colors.black54,
                      //         label: Text(afterEventdate),
                      //       ),
                      //       InputChip(
                      //         onPressed: () {},
                      //         onDeleted: () {
                      //           setState(() {
                      //             afterEventdate = '';
                      //           });
                      //         },
                      //         avatar: const Icon(
                      //           Icons.date_range_outlined,
                      //           size: 20,
                      //           color: Colors.black54,
                      //         ),
                      //         deleteIconColor: Colors.black54,
                      //         label: Text(afterEventdate),
                      //       )
                      //     ],
                      //   ),
                      //   SizedBox(
                      //     height: 5,
                      //   ),
                      // ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TabBarViewMyEvent()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.favorite,
                                          size: 50,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text("กลุ่มที่ติดตาม"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MyGang(
                                              numpage: 1,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.how_to_reg,
                                          size: 50,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text("ที่เข้าร่วม"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TabBarViewProfile()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.admin_panel_settings,
                                          size: 50,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        "จัดการก๊วน",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Calender()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            15), // Add border radius
                                        border: Border.all(
                                          color: Color(
                                              0xFFF0F0F0), // Choose your border color
                                          width:
                                              5, // Specify the width of the border
                                        ),
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Color(0xFFF0F0F0),
                                        child: Icon(
                                          Icons.calendar_month,
                                          size: 50,
                                          color: Color(0xFF013C58),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text("ตารางกิจกรรม"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 7,
                      ),
                      if (loadingHis) ...[
                        CircularProgressIndicator()
                      ] else ...[
                        if (historyData.length == 0) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TabBarViewFindEvent()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(234, 245, 255, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ดูเหมือนวันคุณยังไม่เคยเข้าร่วมกิจกรรมไหน',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 66, 66, 66),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start, // ให้ข้อความเริ่มต้นทางซ้ายของ Row
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // ให้เนื้อหาใน Column อยู่กึ่งกลางตามแนวดิ่ง
                                      children: [
                                        Text(
                                          'เริ่มหาก๊วนเลย!',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 66, 66, 66),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Column(
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
                                          padding: EdgeInsets.only(left: 8),
                                          child:
                                              Text('ประวัติการเข้าร่วมกิจกรรม',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 66, 66, 66),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  )),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HistoryScreen(),
                                              ),
                                            );
                                          },
                                          child: Text('ดูทั้งหมด'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.0),
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: historyData.map<Widget>((items) {
                                      return Container(
                                        width: 240.0,
                                        child: Card(
                                            elevation: 4, // เพิ่มเงากรอบ
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // กำหนดรูปร่างของการ์ด
                                            ),
                                            child: Column(
                                              children: [
                                                Wrap(
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        items['clubname'],
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF013C58),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 0,
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Color(
                                                                    0xFFFF3333),
                                                                size: 16.0,
                                                              ),
                                                              ConstrainedBox(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.4), // Adjust the value as needed
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    items[
                                                                        'placename'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF929292),
                                                                      fontSize:
                                                                          12,
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
                                                                size: 16.0,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  formattingDate(
                                                                      items[
                                                                          'eventdate_start'],
                                                                      items[
                                                                          'eventdate_end']),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF929292),
                                                                    fontSize:
                                                                        12,
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
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'ดูกลุ่ม',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios, // เพิ่มไอคอน ios reward
                                                              color:
                                                                  Colors.blue,
                                                              size:
                                                                  20, // ปรับขนาดไอคอนตามต้องการ
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/badHome.jpg'),
                            colorFilter: ColorFilter.mode(
                              Color.fromARGB(255, 56, 56, 56),
                              BlendMode.hardLight,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่ม
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // ให้ข้อความเริ่มต้นทางซ้ายของ Row
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // ให้เนื้อหาใน Column อยู่กึ่งกลางตามแนวดิ่ง
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserLevelScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'เช็คระดับผู้เล่นของคุณ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Text(
                      //   widget.token,
                      //   style: TextStyle(
                      //     color: const Color.fromARGB(255, 0, 0, 0),
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     height: 0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

BoxDecoration _buildBoxUser() {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 4,
        offset: Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
    borderRadius: BorderRadius.circular(5.0),
    color: Color(0xFFEFEFEF),
  );
}

class ChipLevel extends StatefulWidget {
  final void Function(Set<String> selectedValues) onChanged;
  final select;
  const ChipLevel({Key? key, this.select, required this.onChanged})
      : super(key: key);

  @override
  _ChipLevelState createState() => _ChipLevelState();
}

class _ChipLevelState extends State<ChipLevel> {
  late Set<String> _selectedValues;
  late List<bool> _isSelected;

  final List<Color> chipColors = [
    Color(0xFF607D8B),
    Color(0xff2962ff),
    Color(0xFF26C6DA),
    Color(0xFFFF9800), // Green
    Color(0xFFFC7FFF),
    Color(0xffff63ca), // Pink
    Color(0xFFA47AFF), // Pink
    Color(0xFF00901F), // Pink
    Color(0xFF00695C),
  ];

  @override
  void initState() {
    super.initState();
    // if (widget.select == '') {
    //   for (int i = 0; i < _isSelected.length; i++) {
    //     _isSelected[i] = false;
    //   }
    // }
    _selectedValues = widget.select;
    _isSelected = List<bool>.filled(9, false);
    setState(() {
      if (widget.select.contains('NB')) {
        _isSelected[0] = true;
      }
      if (widget.select.contains('N-')) {
        _isSelected[1] = true;
      }
      if (widget.select.contains('N')) {
        _isSelected[2] = true;
      }
      if (widget.select.contains('S')) {
        _isSelected[3] = true;
      }
      if (widget.select.contains('P-')) {
        _isSelected[4] = true;
      }
      if (widget.select.contains('P')) {
        _isSelected[5] = true;
      }
      if (widget.select.contains('P+')) {
        _isSelected[6] = true;
      }
      if (widget.select.contains('C')) {
        _isSelected[7] = true;
      }
      if (widget.select.contains('C+')) {
        _isSelected[8] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 3.0,
        children: List.generate(9, (index) {
          return ChoiceChip(
            pressElevation: 0.0,
            selectedColor: chipColors[index],
            backgroundColor: Colors.grey[100],
            label: Text(
              _getLevel(index),
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            selected: _isSelected[index],
            onSelected: (bool selected) {
              setState(() {
                _isSelected[index] = selected;
                if (selected) {
                  _selectedValues.add(_getLevel(index));
                } else {
                  _selectedValues.remove(_getLevel(index));
                }
              });
              // Call the onChanged callback to send the selected values to Filter
              widget.onChanged(_selectedValues);
            },
          );
        }),
      ),
    );
  }

  String _getLevel(int index) {
    switch (index) {
      case 0:
        return "NB";
      case 1:
        return "N-";
      case 2:
        return "N";
      case 3:
        return "S";
      case 4:
        return "P-";
      case 5:
        return "P";
      case 6:
        return "P+";
      case 7:
        return "C";
      case 8:
        return "C+";
      default:
        return "";
    }
  }
}
