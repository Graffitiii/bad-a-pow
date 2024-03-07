import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Color(0xFF013C58)),
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.tune, size: 22),
        color: Color(0xFF013C58),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.8,
                child: Center(
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
                            )),
                        pageDivider(),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                        buildTextFieldWithTitle("กำหนดระยะทาง", "ระยะทาง*"),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                        ChipDateWeek(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "เวลา",
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: YourWidget(),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.remove,
                                    size: 30,
                                    color: Color(0xFF013C58),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: YourWidget(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                        ChipLevel(),
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
                                        borderRadius: BorderRadius.circular(
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
                                      // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่มค้นหา
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(
                                          0xFF013C58), // สีพื้นหลังของปุ่ม
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // รูปทรงของปุ่ม
                                      ),
                                    ),
                                    child: Text(
                                      'ค้นหา',
                                      style: TextStyle(
                                        color:
                                            Colors.white, // สีของตัวอักษรในปุ่ม
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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
          child: SizedBox(
            height: 40.0,
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
      ),
    ],
  );
}

// class Date {
//   final String? name;
//   Date({this.name});
// }

// List<Date> DateList = [
//   Date(name: 'จันทร์'),
//   Date(name: 'อังคาร'),
//   Date(name: 'พุธ'),
//   Date(name: 'พฤหัสบดี'),
//   Date(name: 'ศุกร์'),
//   Date(name: 'เสาร์'),
//   Date(name: 'อาทิตย์')
// ];

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
  @override
  _ChipLevelState createState() => _ChipLevelState();
}

class _ChipLevelState extends State<ChipLevel> {
  Set<int> _selectedValues = Set<int>();

  // สีของแต่ละ ChoiceChip ตามลำดับ
  final List<Color> chipColors = [
    Color(0xFFF5A201),
    Color(0xFFFC7FFF),
    Color(0xFF43DC65),
  ];

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

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  TextEditingController _startTimeController = TextEditingController();

  @override
  void dispose() {
    _startTimeController.dispose();
    super.dispose();
  }

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
              _startTimeController.text = formattedTime;
            }
          },
          child: Container(
            decoration: _buildBoxUser(),
            child: Center(
              child: TextFormField(
                controller: _startTimeController,
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
