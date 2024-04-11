import 'dart:collection';

import 'package:finalmo/screen/Event/gangDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _eventsList = {};

  var eventList;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _populateEvents();
    initializeState();
  }

  void initializeState() async {
    await initSharedPref();
  }

  void _populateEvents() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getJoinEvent', queryParameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      eventList = jsonResponse['data'];

      // print("kgkgkkgg: $eventList");
      for (var event in eventList) {
        DateTime eventDate = DateTime.parse(event['eventdate_start']).toLocal();
        DateTime eventDateE = DateTime.parse(event['eventdate_end']).toLocal();

        String clubName = event['club'];
        String id_event = event['_id'];

        if (_eventsList.containsKey(eventDate)) {
          _eventsList[eventDate]!.add({
            'clubName': clubName,
            'id': id_event,
            'timeS': eventDate,
            'timeE': eventDateE,
          });
        } else {
          _eventsList[eventDate] = [
            {
              'clubName': clubName,
              'id': id_event,
              'timeS': eventDate,
              'timeE': eventDateE,
            }
          ];
        }
      }

      setState(() {});
    } else {
      print('Failed to load events: ${response.statusCode}');
    }
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List<Map<String, dynamic>>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List<Map<String, dynamic>> _getEventForDay(DateTime day) {
      List<Map<String, dynamic>> events = _events[day] ?? [];
      return events;
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "ตารางกิจกรรมของฉัน",
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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            eventLoader: _getEventForDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 20, left: 25),
          //   child: Row(children: [
          //     Icon(
          //       Icons.alarm,
          //       color: Color(0xFFFF3333),
          //       size: 25.0,
          //     ),
          //     Container(
          //       margin: EdgeInsets.only(left: 5),
          //       child: Text(
          //         'กำลังจะมาถึง',
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 14,
          //           fontWeight: FontWeight.w600,
          //           height: 0,
          //         ),
          //       ),
          //     ),
          //   ]),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var event = _getEventForDay(_selectedDay!)[index];
                return ListTile(
                  title: Text(
                    event['clubName'],
                    style: TextStyle(
                      color: Color(0xFF013C58),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 0,
                    ),
                  ),
                  subtitle: Text(
                    'วันที่ ${DateFormat('dd MMMM yyyy เวลา HH:mm', 'th').format(event['timeS'])} - ${DateFormat('HH:mm น.').format(event['timeE'])}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    // print(_selectedDay);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                GangDetail(id: event['id'])));
                  },
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(), // เพิ่มเส้นแบ่งระหว่างรายการ
              itemCount: _getEventForDay(_selectedDay!).length,
            ),
          ),
        ],
      ),
    );
  }
}
