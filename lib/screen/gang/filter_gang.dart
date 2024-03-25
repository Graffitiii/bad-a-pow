import 'package:finalmo/screen/add.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';

class Filter extends StatefulWidget {
  final level;

  const Filter({this.level, Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  TextEditingController eventtime = TextEditingController();
  TextEditingController eventdate = TextEditingController();
  String formattedStartTime = '';
  String formattedEndTime = '';
  late Set<String> _selectedValues = {};
  var filterlist = {};
  var jsonResponse;
  bool status = true;
  bool loading = true;

  final _formKey = GlobalKey<FormState>();

  void initState() {
    print(_selectedValues);
    getFilters(widget.level);
    super.initState();
  }

  void getFilters(level) async {
    var queryParameters = {
      'level': _selectedValues,
      // 'eventdate_start': "${eventdate.text} $formattedStartTime",
    };
    var uri = Uri.http(getUrl, '/getFilter', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      setState(() {
        filterlist = jsonResponse;
      });
      print(filterlist);
      // for (var item in jsonResponse['success']) {
      //   print(item['club']);
      // }
    } else {
      print(response.statusCode);
    }

    // setState(() {
    //   loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xFF013C58)),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
          child: IconButton(
            icon: Icon(Icons.tune, size: 23),
            color: Color(0xFF013C58),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Text("ที่อยู่ของฉัน"),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่ม
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'ดูทั้งหมด',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                child: Row(
                                  children: [
                                    buildLocationRow(
                                      "อาคารเรียนรวม บร.2",
                                      "ตำบล คลองหนึ่ง อำเภอ คลองหลวง ปทุมธานี 12120",
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 25,
                                              color: Color(0xFF02D417),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              pageDivider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                child: Row(
                                  children: [
                                    buildLocationRow(
                                      "ฟิวเจอร์พาร์ค รังสิต",
                                      "ตำบล คลองหนึ่ง อำเภอคลองหลวง ปทุมธานี 12120",
                                    ),
                                  ],
                                ),
                              ),
                              pageDivider(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(
                                          0xFF013C58), // ตั้งค่าสีเส้นขอบเป็นสีน้ำเงิน
                                      width: 2, // กำหนดความกว้างของเส้นขอบ
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        15), // กำหนดรูปทรงของขอบเส้น
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: FloatingActionButton.extended(
                                          onPressed: () {
                                            _launchMaps();
                                          },
                                          backgroundColor: Color(0xFFEFEFEF),
                                          label: const Text(
                                            'เพิ่มที่อยู่',
                                            style: TextStyle(
                                              color: Color(0xFF013C58),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.add_circle,
                                            color: Color(0xFF013C58),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              pageDivider(),
                              buildTextFieldWithTitle(
                                  "กำหนดระยะทาง", "ระยะทาง*"),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      'วัน',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ChipDateWeek(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Container(
                                        width: 370,
                                        height: 50,
                                        child: DatePicker(
                                          eventdate: eventdate,
                                        ),
                                      ),
                                    ),
                                  ]),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          "เวลาเริ่ม",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Material(
                                  //   child: Flexible(
                                  //     child: Padding(
                                  //       padding: EdgeInsets.symmetric(
                                  //           vertical: 0, horizontal: 30),
                                  //       child: Row(
                                  //         children: [
                                  //           Expanded(
                                  //             child: TimePick(
                                  //               eventtime: eventtime,
                                  //               startTime: (startTime) {
                                  //                 setState(() {
                                  //                   formattedStartTime =
                                  //                       startTime;
                                  //                   // print(formattedStartTime);
                                  //                 });
                                  //               },
                                  //               endTime: (endTime) {
                                  //                 setState(() {
                                  //                   formattedEndTime = endTime;
                                  //                   // print(formattedEndTime);
                                  //                 });
                                  //               },
                                  //             ),
                                  //           ),
                                  //           Icon(
                                  //             Icons.remove,
                                  //             size: 30,
                                  //             color: Color(0xFF013C58),
                                  //           ),
                                  //           Expanded(
                                  //             child: TimePick(
                                  //               eventtime: eventtime,
                                  //               startTime: (startTime) {
                                  //                 setState(() {
                                  //                   formattedStartTime =
                                  //                       startTime;
                                  //                   // print(formattedStartTime);
                                  //                 });
                                  //               },
                                  //               endTime: (endTime) {
                                  //                 setState(() {
                                  //                   formattedEndTime = endTime;
                                  //                   // print(formattedEndTime);
                                  //                 });
                                  //               },
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'ระดับของผู้เล่น',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ChipLevel(
                                    onChanged: (values) {
                                      // Update the selected values in Filter
                                      setState(() {
                                        _selectedValues = values;
                                      });
                                      // Print the selected values in Filter
                                      print(_selectedValues);
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: FractionallySizedBox(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่มล้างข้อมูล
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(
                                                    0xFFEFEFEF), // สีพื้นหลังของปุ่ม
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // รูปทรงของปุ่ม
                                                ),
                                              ),
                                              child: Text(
                                                'ล้าง',
                                                style: TextStyle(
                                                  color: Color(
                                                      0xFF013C58), // สีของตัวอักษรในปุ่ม
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: FractionallySizedBox(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                getFilters(level);
                                                // Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color(
                                                    0xFF013C58), // สีพื้นหลังของปุ่ม
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // รูปทรงของปุ่ม
                                                ),
                                              ),
                                              child: Text(
                                                'ค้นหา',
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // สีของตัวอักษรในปุ่ม
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}

Widget pageDivider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
    child: Container(
      width: 350,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFEBEBEB),
          ),
        ),
      ),
    ),
  );
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

InputDecoration _buildInputUser(String labelText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(5.0),
    ),
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.black.withOpacity(0.3100000023841858),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    border: InputBorder.none,
    filled: true,
    fillColor: Color(0xFFEFEFEF),
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
  );
}

Widget buildTextFieldWithTitle(String title, String hintText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          decoration: _buildBoxUser(),
          child: TextFormField(
            decoration: _buildInputUser(hintText),
            // onSaved: (String password) {
            //   profile.password = password;
            // },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
        ),
      ),
    ],
  );
}

_launchMaps() async {
  // พิกัดที่ต้องการ (เช่นละติจูดและลองจิจูดของสถานที่ที่ต้องการ)
  final latitude = 13.7563;
  final longitude = 100.5018;

  // URL ของ Google Maps ที่มีพิกัดที่ต้องการ
  final url =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  // เปิด Google Maps ในอุปกรณ์ของผู้ใช้
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'ไม่สามารถเปิด Google Maps ได้: $url';
  }
}

Widget buildLocationRow(String locationName, String address) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.location_on,
            size: 15,
            color: Color(0xFF013C58),
          ),
          SizedBox(width: 10),
          Text(
            locationName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Icon(
            Icons.border_color,
            size: 15,
            color: Color(0xFF013C58),
          ),
          SizedBox(width: 10),
          Text(
            address,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ],
      ),
    ],
  );
}

class ChipDateWeek extends StatefulWidget {
  @override
  _ChipDateWeekState createState() => _ChipDateWeekState();
}

class _ChipDateWeekState extends State<ChipDateWeek> {
  Set<int> _selectedValues = Set<int>();

  // สีของแต่ละ ChoiceChip ตามลำดับ
  final List<Color> chipColors = [
    Color(0xFFF5A201),
    Color(0xFFFC7FFF),
    Color(0xFF43DC65),
    Color(0xFFF56701),
    Color(0xFF1AD1F9),
    Color(0xFFCC00FF),
    Color(0xFFFF0000),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 3.0,
        children: List.generate(7, (index) {
          return ChoiceChip(
            pressElevation: 0.0,
            selectedColor: chipColors[index],
            backgroundColor: Colors.grey[100],
            label: Text(_getDayOfWeekName(index),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis),
            selected: _selectedValues.contains(index),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedValues.add(index);
                } else {
                  _selectedValues.remove(index);
                }
              });
            },
          );
        }),
      ),
    );
  }

  String _getDayOfWeekName(int index) {
    switch (index) {
      case 0:
        return "จันทร์";
      case 1:
        return "อังคาร";
      case 2:
        return "พุธ";
      case 3:
        return "พฤหัสบดี";
      case 4:
        return "ศุกร์";
      case 5:
        return "เสาร์";
      case 6:
        return "อาทิตย์";
      default:
        return "";
    }
  }
}

class ChipLevel extends StatefulWidget {
  final void Function(Set<String> selectedValues) onChanged;

  const ChipLevel({Key? key, required this.onChanged}) : super(key: key);

  @override
  _ChipLevelState createState() => _ChipLevelState();
}

class _ChipLevelState extends State<ChipLevel> {
  late Set<String> _selectedValues;
  late List<bool> _isSelected;

  final List<Color> chipColors = [
    Color(0xFFF5A201),
    Color(0xFFFC7FFF),
    Color(0xFF43DC65),
  ];

  @override
  void initState() {
    super.initState();
    _selectedValues = {};
    _isSelected = List<bool>.filled(3, false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 3.0,
        children: List.generate(3, (index) {
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
        return "N";
      case 1:
        return "S";
      case 2:
        return "P";
      default:
        return "";
    }
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
    return Expanded(
      child: FractionallySizedBox(
        child: GestureDetector(
          onTap: () async {
            TimeOfDay? time = await getTime(
              context: context,
              title: "Select Your Start Time",
            );
            if (time != null) {
              String formattedTime = formatTime(time);
              eventtime.text = formattedTime;
            }
          },
          child: Container(
            decoration: _buildBoxUser(),
            child: Center(
              child: TextFormField(
                controller: eventtime,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Click to select start time',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
      cancelText: cancelText ?? "Cancel",
      confirmText: confirmText ?? "Save",
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

  String formatTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
