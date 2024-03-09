import 'dart:convert';
import 'package:finalmo/postModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

typedef TodoListCallback = void Function();

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

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  // late String userId;
  TextEditingController club = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController priceBadminton = TextEditingController();
  TextEditingController priceplay = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController eventdate = TextEditingController();
  TextEditingController eventtime = TextEditingController();
  String formattedStartTime = '';
  String formattedEndTime = '';
  List<String> selectedlevel = [];
  List<EventList> eventlist = [];

  final _formKey = GlobalKey<FormState>();

  void getTodoList(TodoListCallback callback) async {
    // โค้ดของ getTodoList() ที่เดิม...

    // เรียกใช้ callback function เมื่อการดึงข้อมูลเสร็จสิ้น
    callback();
  }

  // void getTodoList() async {
  //   var response = await http.get(
  //     Uri.parse(getToDoList),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);

  //     jsonResponse['clublistdata'].forEach((value) => eventlist.add(EventList(
  //           club: value['club'],
  //           contact: value['contact'],
  //           priceBadminton: value['price_badminton'],
  //           priceplay: value['priceplay'],
  //           level: value['level'],
  //           brand: value['brand'],
  //           details: value['details'],
  //         )));

  //     print(jsonResponse);
  //   } else {
  //     print(response.statusCode);
  //   }
  //   // items = jsonResponse['clublistdata'];
  //   // List<EventList> eventlist = [],

  //   // print(jsonResponse);
  //   setState(() {});
  // }

  void addTodo() async {
    if (club.text.isNotEmpty &&
        contact.text.isNotEmpty &&
        priceBadminton.text.isNotEmpty &&
        priceplay.text.isNotEmpty) {
      var regBody = {
        // "userId": userId,
        "club": club.text,
        "contact": contact.text,
        "eventdate_start": "${eventdate.text} $formattedStartTime",
        "eventdate_end": "${eventdate.text} $formattedEndTime",
        "price_badminton": priceBadminton.text,
        "priceplay": priceplay.text,
        "level": selectedlevel,
        "brand": brand.text,
        "details": details.text,
      };

      var response = await http.post(Uri.parse(createEvent),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.pop(context);
        // print(jsonResponse['clublistdata']);
        getTodoList(() {
          // เมื่อ getTodoList() เสร็จสิ้น สามารถทำอะไรก็ได้ในนี้
        });
      } else {
        print("error");
      }
    }
    // print(selectedlevel);
    // print(formattedStartTime);
    // print(formattedEndTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "เพิ่มก๊วน",
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: Container(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Color(0xFF013C58)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      'เพิ่มรูปภาพ',
                      style: TextStyle(
                        color: Color(0xFF013C58),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: club,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'ชื่อก๊วน',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      fillColor: Color(0xFFEFEFEF),
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
                    // keyboardType: TextInputType.emailAddress,
                    // onSaved: (String email) {
                    //   profile.email = email;
                    // },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 200,
                            height: 50,
                            child: DatePicker(
                              eventdate: eventdate,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            width: 200,
                            height: 50,
                            child: TimePick(
                              eventtime: eventtime,
                              startTime: (startTime) {
                                setState(() {
                                  formattedStartTime = startTime;
                                  // print(formattedStartTime);
                                });
                              },
                              endTime: (endTime) {
                                setState(() {
                                  formattedEndTime = endTime;
                                  // print(formattedEndTime);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'สถานที่',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      fillColor: Color(0xFFEFEFEF),
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

                    // onSaved: (String email) {
                    //   profile.email = email;
                    // },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelText: 'จำนวน (คน)',
                              labelStyle: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.3100000023841858),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Color(0xFFEFEFEF),
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
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'ระดับของผู้เล่น',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black
                                      .withOpacity(0.3100000023841858),
                                ),
                              ),
                              items: level.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          selectedlevel.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? selectedlevel.remove(item)
                                              : selectedlevel.add(item);
                                          //This rebuilds the StatefulWidget to update the button's text
                                          setState(() {});
                                          //This rebuilds the dropdownMenu Widget to update the check mark
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              if (isSelected)
                                                const Icon(
                                                    Icons.check_box_outlined)
                                              else
                                                const Icon(Icons
                                                    .check_box_outline_blank),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                              value: selectedlevel.isEmpty
                                  ? null
                                  : selectedlevel.last,
                              onChanged: (value) {},
                              selectedItemBuilder: (context) {
                                return level.map(
                                  (item) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        selectedlevel.join(', '),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    );
                                  },
                                ).toList();
                              },
                              buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(left: 16, right: 8),
                                  height: 48,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFEFEFEF),
                                      borderRadius: BorderRadius.all(
                                          (Radius.circular(5.0))))),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: contact,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'ติดต่อ',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      fillColor: Color(0xFFEFEFEF),
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
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],

                    // onSaved: (String email) {
                    //   profile.email = email;
                    // },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: brand,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'ยี่ห้อลูกแบด',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      fillColor: Color(0xFFEFEFEF),
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

                    // onSaved: (String email) {
                    //   profile.email = email;
                    // },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextFormField(
                            controller: priceplay,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelText: 'ค่าเล่น',
                              labelStyle: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.3100000023841858),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Color(0xFFEFEFEF),
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
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextFormField(
                            controller: priceBadminton,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelText: 'ค่าลูก',
                              labelStyle: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.3100000023841858),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              fillColor: Color(0xFFEFEFEF),
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: details,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'รายละเอียดเพิ่มเติม',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      fillColor: Color(0xFFEFEFEF),
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      border: InputBorder.none,
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.red),
                      ),
                      errorStyle: TextStyle(fontSize: 12),
                    ),
                    maxLines: 3,
                    minLines: 3,

                    // onSaved: (String email) {
                    //   profile.email = email;
                    // },
                  ),
                  Container(
                    width: 150,
                    height: 85,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 5,
                              offset: Offset(0, 7),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            addTodo();
                            // getTodoList();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF013C58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0, // Remove default button elevation
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'เพิ่ม',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))),
      )),
    );
  }
}

class DatePicker extends StatelessWidget {
  final TextEditingController eventdate;
  DatePicker({Key? key, required this.eventdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextField(
        controller: eventdate,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.grey,
          ),
          labelText: "Enter Date",
          labelStyle: TextStyle(
            color: Colors.black.withOpacity(0.3100000023841858),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Color(0xFFEFEFEF),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat.yMd().format(pickedDate);

            eventdate.text = formattedDate.toString();
            // print(eventdate.text);
          } else {
            print("Not selected");
          }
        },
      ),
    );
  }
}

class TimePick extends StatefulWidget {
  final TextEditingController eventtime;
  final Function(String) startTime;
  final Function(String) endTime;

  TimePick(
      {Key? key,
      required this.eventtime,
      required this.startTime,
      required this.endTime})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TimePickState();
  }
}

class _TimePickState extends State<TimePick> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
  TextEditingController eventtime = TextEditingController();
  String formattedStartTime = '';
  String formattedEndTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        TextField(
          controller: eventtime,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.timer,
              color: Colors.grey,
            ),
            labelText: "Enter Time",
            labelStyle: TextStyle(
              color: Colors.black.withOpacity(0.3100000023841858),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: Color(0xFFEFEFEF),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
          readOnly: true,
          onTap: () async {
            TimeRange? result = await showTimeRangePicker(
                context: context,
                start: const TimeOfDay(hour: 9, minute: 0),
                end: const TimeOfDay(hour: 12, minute: 0),
                disabledColor: Colors.red.withOpacity(0.5),
                strokeWidth: 4,
                ticks: 24,
                ticksOffset: -7,
                ticksLength: 15,
                ticksColor: Colors.grey,
                labels: [
                  "12 am",
                  "3 am",
                  "6 am",
                  "9 am",
                  "12 pm",
                  "3 pm",
                  "6 pm",
                  "9 pm"
                ].asMap().entries.map((e) {
                  return ClockLabel.fromIndex(
                      idx: e.key, length: 8, text: e.value);
                }).toList(),
                labelOffset: 35,
                rotateLabels: false,
                padding: 60);

            if (kDebugMode) {
              if (result != null) {
                // ดึงข้อมูลเวลาเริ่มและเวลาสิ้นสุด
                TimeOfDay startTime = result.startTime;
                TimeOfDay endTime = result.endTime;

                // ฟอร์แมตเวลาให้เป็นรูปแบบที่ต้องการ
                String formattedStartTime =
                    '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';

                String formattedEndTime =
                    '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';

                widget.startTime(formattedStartTime);
                widget.endTime(formattedEndTime);

                // print('Pick time: $formattedStartTime - $formattedEndTime');
                eventtime.text = '$formattedStartTime - $formattedEndTime';
                print('time: ' + eventtime.text);
                setState(() {});
              } else {
                print("ไม่ได้เลือกเวลา");
              }
            }
          },
        ),
      ]),
    );
  }
}

// class DropdownLevel extends StatefulWidget {
//   const DropdownLevel({super.key});

//   @override
//   State<DropdownLevel> createState() => _DropdownLevelState();
// }

// class _DropdownLevelState extends State<DropdownLevel> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       label: const Text('ระดับของผู้เล่น',style: TextStyle(
//                           color: Color.fromARGB(255, 174, 174, 174),        
//                           fontSize: 14,
//                           
//                           fontWeight: FontWeight.w400,
//                                 ),),
//       inputDecorationTheme: InputDecorationTheme(
//         fillColor: Color(0xFFEFEFEF),
//         filled: true,
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(width: 1.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.circular(5.0),
//         ),
//       ),
//       // initialSelection:Null,
//       onSelected: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(value: value, label: value);
//       }).toList(),
//     );
//   }
// }
