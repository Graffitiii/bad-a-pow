import 'package:finalmo/screen/Event/gangOwnerDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String username = '';
  var myToken;
  late SharedPreferences prefs;

  var historyData;
  bool loading = true;

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
    var queryParameters = {
      'username': username,
    };

    var uri = Uri.http(getUrl, '/findHistory', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        historyData = jsonResponse['result'];
      });

      print(historyData);
      setState(() {
        loading = false;
      });
    }
  }

  String formattingDate(start, end) {
    initializeDateFormatting('th', null);

    DateTime eventStart = DateTime.parse(start);
    DateTime eventEnd = DateTime.parse(end);
    DateTime thaiDateStartTime = eventStart.add(Duration(hours: 7));
    DateTime thaiDateEndTime = eventEnd.add(Duration(hours: 7));

    // Convert year from Gregorian calendar (AD) to Buddhist calendar (BE)
    int buddhistYearStart = thaiDateStartTime.year + 543;
    int buddhistYearEnd = thaiDateEndTime.year + 543;

    String formattedDateTime =
        DateFormat('d MMMM yyyy H:mm', 'th').format(thaiDateStartTime);

    String formattedEndTime =
        DateFormat('H:mm น.', 'th').format(thaiDateEndTime);

    // Format with Buddhist year (BE)
    formattedDateTime = formattedDateTime.replaceFirst(
        thaiDateStartTime.year.toString(), buddhistYearStart.toString());
    formattedEndTime = formattedEndTime.replaceFirst(
        thaiDateEndTime.year.toString(), buddhistYearEnd.toString());

    return formattedDateTime + " - " + formattedEndTime;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffe9ecf3),
          fontFamily: "Noto" // กำหนดสีพื้นหลังของหน้า
          ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "ประวัติการเล่น",
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
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // จัด Widget ทั้งหมดให้อยู่ข้างทางขวาและซ้าย
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 20, 15, 20),
                                    child: Text(
                                      'ประวัติการเล่นของคุณ',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.history, // เพิ่มไอคอน ios reward
                                    color: Color(0xFF00537A),
                                    size: 24, // ปรับขนาดไอคอนตามต้องการ
                                  ),
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: Text('ดูทั้งหมด'),
                                  // ),
                                ],
                              ),
                              if (loading) ...[
                                SizedBox(height: 10),
                                CircularProgressIndicator(
                                  color: Color(0xFF00537A),
                                ),
                                SizedBox(height: 20)
                              ] else ...[
                                ...historyData.map<Widget>((items) {
                                  return Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        GangOwnerDetail(
                                                          club:
                                                              items['clubname'],
                                                          pop: "pop",
                                                        )));
                                      },
                                      child: Container(
                                        height: 120,
                                        child: Card(
                                          color: Color.fromARGB(
                                              255, 244, 253, 255),
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    items['clubname'],
                                                    style: TextStyle(
                                                      color: Color(0xFF013C58),
                                                      fontSize: 20,
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
                                                            Icons.location_on,
                                                            color: Color(
                                                                0xFFFF3333),
                                                            size: 18.0,
                                                          ),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.65), // Adjust the value as needed
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
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
                                                                  fontSize: 15,
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
                                                        height: 5,
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
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              formattingDate(
                                                                  items[
                                                                      'eventdate_start'],
                                                                  items[
                                                                      'eventdate_end']),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF929292),
                                                                fontSize: 15,
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
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5)
                                  ]);
                                }).toList()
                              ],
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
