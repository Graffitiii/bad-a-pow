import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsList = {
      DateTime.now().subtract(Duration(days: 2)): ['Event A1', 'Event B1'],
      DateTime.now(): ['Event A2', 'Event B2', 'Event C1', 'Event D1'],
      DateTime.now().add(Duration(days: 1)): [
        'Event A3',
        'Event B3',
        'Event C2',
        'Event D2'
      ],
      DateTime.now().add(Duration(days: 3)):
          Set.from(['Event A4', 'Event A5', 'Event B4']).toList(),
      DateTime.now().add(Duration(days: 7)): [
        'Event A6',
        'Event B5',
        'Event C3'
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางกิจกรรมของฉัน'),
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
                _getEventForDay(selectedDay);
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          ListView(
            shrinkWrap: true,
            children: _getEventForDay(_selectedDay!)
                .map((event) => ListTile(
                      title: Text(event.toString()),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
