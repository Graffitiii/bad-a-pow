import 'dart:convert';
import 'dart:io';
import 'package:finalmo/postModel.dart';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

typedef TodoListCallback = void Function();

// const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
final List<String> level = [
  'N',
  'S',
  'P',
];

final List<String> clubname = [];

class EditEvent extends StatefulWidget {
  final id;
  const EditEvent({this.id, Key? key}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
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
  List<String> imageBody = [];

  String? selectedclub;
  // List<EventList> eventlist = [];

  late String username;
  late SharedPreferences prefs;
  var myToken;

  var jsonResponse;
  bool status = false;
  bool loading = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  List<File> images = [];

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  var eventDetail;
  File? _photo;
  // String? levelSelect;

  List<String> downloadUrls = [];
  String dateEnd = '';
  String dateStart = '';

  void initState() {
    initializeState();
    super.initState();
    setState(() {
      eventDetail = widget.id;
    });
    print("detail :  $eventDetail");
    setDefault();
  }

  void getTodoList(TodoListCallback callback) async {
    // โค้ดของ getTodoList() ที่เดิม...

    // เรียกใช้ callback function เมื่อการดึงข้อมูลเสร็จสิ้น
    callback();
  }

  Future getMultiImage() async {
    final List<XFile>? pickedImage = await _picker.pickMultiImage();

    if (pickedImage != null) {
      pickedImage.forEach((e) {
        images.add(File(e.path));
      });

      setState(() {});
    }

    print(images);
  }

  void initializeState() async {
    await initSharedPref();
    getClubList();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  void getClubList() async {
    print("ชื่อผู้ใช้ :" + username);
    setState(() {
      loading = true;
    });
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getOwnerClub', queryParameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);

      clubname.clear();
      for (var item in jsonResponse['data']) {
        // print(item['clubname']);
        clubname.add(item['clubname']);
      }
      // print(jsonResponse['data'][0]['clubname']);
      print(clubname);
      status = true;

      setState(() {
        loading = false;
      });
    } else {
      status = true;

      print(response.statusCode);
    }
  }

  void setDefault() async {
    String formattedDate = '';
    String formattedTime_start = '';
    String formattedTime_end = '';
    String formattedTime = '';
    setState(() {
      try {
        String originalDateString = eventDetail['eventdate_start'];
        String originalTimeString = eventDetail['eventdate_end'];

        String dateOnlyString = originalDateString.split('T')[0];
        String timeString_start = originalDateString.substring(11, 19);
        String timeString_end = originalTimeString.substring(11, 19);

        DateTime eventDate = DateFormat('yyyy-MM-dd').parse(dateOnlyString);
        DateTime eventTime_start =
            DateTime.parse(originalDateString).add(Duration(hours: 7));
        DateTime eventTime_end =
            DateTime.parse(originalTimeString).add(Duration(hours: 7));

        formattedDate = DateFormat('M/d/yyyy').format(eventDate);
        formattedTime_start = DateFormat('HH:mm').format(eventTime_start);
        formattedTime_end = DateFormat('HH:mm').format(eventTime_end);
        formattedTime = '$formattedTime_start - $formattedTime_end';
        // print(formattedDate); // หรือทำอย่างอื่นต่อไปที่ต้องการ
        // print(formattedTime); // หรือทำอย่างอื่นต่อไปที่ต้องการ
      } catch (e) {
        print('เกิดข้อผิดพลาดในการแปลง String เป็น DateTime: $e');
      }
      eventDetail['eventdate_start'] = formattedDate;
      eventDetail['eventdate_end'] = formattedTime;
      // print("CSC" + eventDetail['eventdate_start']);
    });

    if (eventDetail['club'] != "") {
      setState(() {
        selectedclub = eventDetail['club'];
      });
    }
    if (eventDetail['contact'] != "") {
      setState(() {
        contact.text = eventDetail['contact'];
      });
    }
    if (eventDetail['eventdate_start'] != "") {
      setState(() {
        eventdate.text = eventDetail['eventdate_start'];
      });
    }
    if (eventDetail['eventdate_end'] != "") {
      print("dsedw" + eventtime.text);

      setState(() {
        eventtime.text = eventDetail['eventdate_end'];
      });
    }
    if (eventDetail['level'] != "") {
      setState(() {
        selectedlevel = (eventDetail['level'] as List<dynamic>).cast<String>();
        // หรือ
        // selectedlevel = (eventDetail['level'] as List<dynamic>).toList().cast<String>();
      });
    }

    if (eventDetail['price_badminton'] != "") {
      setState(() {
        priceBadminton.text = eventDetail['price_badminton'];
      });
    }
    if (eventDetail['priceplay'] != "") {
      setState(() {
        priceplay.text = eventDetail['priceplay'];
      });
    }
    if (eventDetail['brand'] != "") {
      setState(() {
        brand.text = eventDetail['brand'];
      });
    }
    if (eventDetail['image'] != "") {
      setState(() {
        downloadUrls = (eventDetail['image'] as List<dynamic>).cast<String>();
        // หรือ
        // selectedlevel = (eventDetail['level'] as List<dynamic>).toList().cast<String>();
      });
    }
    if (eventDetail['details'] != "") {
      setState(() {
        details.text = eventDetail['details'];
      });
    }
    print("newdetail :  $eventDetail");
  }

  void saveEvent() async {
    var regBody;
    if (images.length != 0) {
      for (int i = 0; i < images.length; i++) {
        String url = await uploadFile(images[i]);
        downloadUrls.add(url);

        if (i == images.length - 1) {
          regBody = {
            "image": downloadUrls,
            "club": selectedclub,
            "contact": contact.text,
            "eventdate_start": "${eventdate.text} $formattedStartTime",
            "eventdate_end": "${eventdate.text} $formattedEndTime",
            "price_badminton": priceBadminton.text,
            "priceplay": priceplay.text,
            "level": selectedlevel,
            "brand": brand.text,
            "details": details.text,
            "active": false
          };

          print(regBody);
        }
      }
    } else {
      regBody = {
        // "userId": userId,
        "club": selectedclub,
        "contact": contact.text,
        "eventdate_start": "${eventdate.text} $formattedStartTime",
        "eventdate_end": "${eventdate.text} $formattedEndTime",
        "price_badminton": priceBadminton.text,
        "priceplay": priceplay.text,
        "level": selectedlevel,
        "brand": brand.text,
        "details": details.text,
        "active": false
      };
    }

    // if (downloadUrls == "") {
    //   setState(() {
    //     imageBody = eventDetail['image'];
    //   });
    // }
    // if (downloadUrls != "") {
    //   imageBody = downloadUrls;
    // }

    // var regBody = {
    //   "club": selectedclub,
    //   "image": imageBody,
    //   "contact": contact.text,
    //   "eventdate_start": "${eventdate.text} $formattedStartTime",
    //   "eventdate_end": "${eventdate.text} $formattedEndTime",
    //   "level": selectedlevel,
    //   "brand": brand.text,
    //   "price_badminton": priceBadminton.text,
    //   "priceplay": priceplay.text,
    //   "details": details.text
    // };
    print(regBody);
    var response = await http.put(Uri.parse(editEvent),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['status']);
    if (jsonResponse['status']) {
      print(jsonResponse['data']);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('บันทึกโปรไฟล์สำเร็จ'),
          content: const Text('บันทึกโปรไฟล์สำเร็จ'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK'); // ปิดกล่องโต้ตอบ
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext context) =>
                //         GangDetail(id: eventDetail['_id']),
                //   ),
                // );

                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => TabBarViewBottom(),
                //     settings: RouteSettings(
                //         name:
                //             'EditEvent'), // กำหนด RouteSettings เพื่อไม่ให้มีปุ่ม back
                //   ),
                //   (route) => false, // ไม่มีเงื่อนไขในการกลับไปยังหน้าก่อนหน้า
                // );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('error');
    }
    // }
  }

  Future<String> uploadFile(File file) async {
    // final fileName = username;
    final destination = 'event_image/${DateTime.now().microsecondsSinceEpoch}';

    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));

    final imageUrl = await ref.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  void deleteEvent(id) async {
    // print(id);
    var regBody = {"_id": id};

    var response = await http.delete(Uri.parse(delEvent),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      // getTodoList();
      // showDialog(
      //   context: context,
      //   builder: (_) {
      //     return AlertDialog(
      //       title: const Text("Dialog Title"),
      //       content: const Text("This is the dialog content."),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             // Define action for Action 1
      //             Navigator.of(context).pop(); // Close the dialog
      //           },
      //           child: const Text("Action 1"),
      //         ),
      //         TextButton(
      //           onPressed: () {
      //             // Define action for Action 2
      //           },
      //           child: const Text("Action 2"),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      print('SDadw');
    }
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
                  GestureDetector(
                    onTap: () async {
                      getMultiImage();
                    },
                    child: Container(
                      height: 120,
                      decoration: ShapeDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Color(0xFF013C58)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: images.length == 0
                            ? Center(
                                child: Text("เพิ่มรูปภาพ"),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return Container(
                                      width: 120,
                                      margin: EdgeInsets.only(right: 5),
                                      // height: 10,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF013C58)),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(
                                            images[i],
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                              right: -10,
                                              top: -10,
                                              child: IconButton(
                                                iconSize: 25,
                                                icon: Icon(
                                                  Icons.cancel,
                                                ),
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                onPressed: () {
                                                  setState(() {
                                                    images.removeAt(i);
                                                  });
                                                },
                                              )),
                                        ],
                                      ));
                                },
                                itemCount: images.length,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[200], // กำหนดสีพื้นหลังของกล่อง Dropdown
                          borderRadius: BorderRadius.circular(
                              5.0), // กำหนดรูปร่างของกล่อง Dropdown
                        ),
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'ชื่อที่ใช้',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.black.withOpacity(0.3100000023841858),
                            ),
                          ),
                          items: clubname
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedclub,
                          onChanged: (String? value) {
                            setState(() {
                              selectedclub = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 48,
                            width: double.infinity,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ),
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                child: Text(
                                  'ลบกิจกรรม',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  elevation: 2,
                                  backgroundColor: Color(0xFFFF5B5B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => {
                                  // deleteEvent(eventDetail['_id']),
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           TabBarViewFindEvent()),
                                  // ),
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('ลบกิจกรรม'),
                                      content: const Text(
                                          'ต้องการลบกิจกรรมใช่หรือไม่'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('ยกเลิก'),
                                        ),
                                        TextButton(
                                          onPressed: () => {
                                            deleteEvent(eventDetail['_id']),
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TabBarViewFindEvent()),
                                            ),
                                          },
                                          child: const Text('ยืนยัน'),
                                        ),
                                      ],
                                    ),
                                  ),
                                },
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: TextButton(
                                  child: Text(
                                    'สำเร็จ',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: Color(0xFF02D417),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => {}),
                            )),
                      ),
                    ],
                  ),
                  // Container(
                  //   width: 150,
                  //   height: 85,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(20),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Color(0x3F000000),
                  //             blurRadius: 5,
                  //             offset: Offset(0, 7),
                  //             spreadRadius: 0,
                  //           ),
                  //         ],
                  //       ),
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           saveEvent();
                  //           Navigator.pop(context, 'OK');
                  //           Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (BuildContext context) =>
                  //                   GangDetail(id: eventDetail['_id']),
                  //             ),
                  //           );
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Color(0xFF013C58),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           elevation: 0, // Remove default button elevation
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(10),
                  //           child: Text(
                  //             'เพิ่ม',
                  //             style: TextStyle(
                  //               fontSize: 14,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
