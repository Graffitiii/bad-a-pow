import 'dart:io';

import 'package:finalmo/config.dart';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/profile/Owner_Apply.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileEdit extends StatefulWidget {
  final profile;
  const ProfileEdit({this.profile, Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  var userInfo;
  List<String> gender = ['ชาย', 'หญิง', 'ไม่ระบุ'];
  List<String> showAge = ['แสดง', 'ไม่แสดง'];
  List<String> level = ['N', 'S', 'P', 'ไม่ระบุ'];
  TextEditingController details = TextEditingController();
  String? genderSelect;
  String? showAgeSelect;
  String? levelSelect;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String imageUrl = '';
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    initSharedPref();
    setState(() {
      userInfo = widget.profile;
    });
    print(userInfo);
    setDefault();
  }

  void setDefault() async {
    if (userInfo['gender'] != "") {
      setState(() {
        genderSelect = userInfo['gender'];
      });
    }
    if (userInfo['level'] != "") {
      setState(() {
        levelSelect = userInfo['level'];
      });
    }
    if (userInfo['ageShow'] == false) {
      setState(() {
        showAgeSelect = 'ไม่แสดง';
      });
    }
    if (userInfo['ageShow'] == true) {
      setState(() {
        showAgeSelect = 'แสดง';
      });
    }
    if (userInfo['about'] != "") {
      setState(() {
        details.text = userInfo['about'];
      });
    }
    if (userInfo['about'] == "") {
      setState(() {
        details.text = "";
      });
    }
  }

  void saveProfile() async {
    if (genderSelect != null && levelSelect != null) {
      bool ageShowBody = false;
      String imageBody = "";
      if (showAgeSelect == 'แสดง') {
        setState(() {
          ageShowBody = true;
        });
      }
      if (showAgeSelect == 'ไม่แสดง') {
        setState(() {
          ageShowBody = false;
        });
      }
      if (imageUrl == "") {
        setState(() {
          imageBody = userInfo['picture'];
        });
      }
      if (imageUrl != "") {
        imageBody = imageUrl;
      }
      var regBody = {
        "userName": userInfo['userName'],
        "picture": imageBody,
        "gender": genderSelect,
        "level": levelSelect,
        "about": details.text,
        "ageShow": ageShowBody
      };
      print(regBody);
      var response = await http.put(Uri.parse(editProfile),
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
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
    print(username);
  }

  Future uploadFile() async {
    if (genderSelect != null && levelSelect != null) {
      if (_photo == null) {
        saveProfile();
      } else {
        final fileName = username;
        final destination = 'profile_image/$fileName';

        try {
          final ref =
              firebase_storage.FirebaseStorage.instance.ref(destination);
          await ref.putFile(
              _photo!, SettableMetadata(contentType: 'image/jpeg'));

          imageUrl = await ref.getDownloadURL();
          print(imageUrl);
          if (imageUrl != "") {
            saveProfile();
          }
        } catch (e) {
          print('error occured');
        }
      }
    } else {
      print('error genderSelect levelSelect');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "ตั้งค่าโปรไฟล์",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'บันทึก',
            onPressed: () {
              uploadFile();
              Navigator.pop(context, 'OK');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => TabBarViewProfile(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(60, 20, 60, 0),
                    child: Center(
                        child: _photo != null
                            ? CircleAvatar(
                                radius: 100,
                                backgroundImage: Image.file(
                                  _photo!,
                                  fit: BoxFit.cover,
                                ).image,
                              )
                            : (_photo == null && userInfo['picture'] == '')
                                ? CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage(
                                        'assets/images/user_default.png'),
                                  )
                                : (_photo == null && userInfo['picture'] != '')
                                    ? CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            NetworkImage(userInfo['picture']),
                                      )
                                    : Container())),
                Positioned(
                  right: 90,
                  bottom: 0,
                  child: ElevatedButton(
                    onPressed: () async {
                      imgFromGallery();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF013C58),
                      shape: CircleBorder(),
                      elevation: 0, // Remove default button elevation
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Color.fromARGB(
                          255, 255, 255, 255) // สีเหลืองถ้าอยู่ในช่วงที่ถูกกด
                      , // สีเทาถ้าไม่ได้ถูกกด
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      userInfo['userName'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'เพศ',
                                style: TextStyle(
                                  color: Color(0xFF013C58),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Expanded(
                                flex: 6,
                                child: DropdownButtonHideUnderline(
                                    child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[
                                        200], // กำหนดสีพื้นหลังของกล่อง Dropdown
                                    borderRadius: BorderRadius.circular(
                                        5.0), // กำหนดรูปร่างของกล่อง Dropdown
                                  ),
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'เลือกเพศ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black
                                            .withOpacity(0.3100000023841858),
                                      ),
                                    ),
                                    items: gender
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: genderSelect,
                                    onChanged: (String? value) {
                                      setState(() {
                                        genderSelect = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 48,
                                      width: double.infinity,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                )))
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'อายุ',
                                style: TextStyle(
                                  color: Color(0xFF013C58),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Expanded(
                                flex: 6,
                                child: DropdownButtonHideUnderline(
                                    child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[
                                        200], // กำหนดสีพื้นหลังของกล่อง Dropdown
                                    borderRadius: BorderRadius.circular(
                                        5.0), // กำหนดรูปร่างของกล่อง Dropdown
                                  ),
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'แสดงอายุ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black
                                            .withOpacity(0.3100000023841858),
                                      ),
                                    ),
                                    items: showAge
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: showAgeSelect,
                                    onChanged: (String? value) {
                                      setState(() {
                                        showAgeSelect = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 48,
                                      width: double.infinity,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                )))
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'ระดับฝีมือ',
                                style: TextStyle(
                                  color: Color(0xFF013C58),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Expanded(
                                flex: 6,
                                child: DropdownButtonHideUnderline(
                                    child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[
                                        200], // กำหนดสีพื้นหลังของกล่อง Dropdown
                                    borderRadius: BorderRadius.circular(
                                        5.0), // กำหนดรูปร่างของกล่อง Dropdown
                                  ),
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'เลือกระดับ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black
                                            .withOpacity(0.3100000023841858),
                                      ),
                                    ),
                                    items: level
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: levelSelect,
                                    onChanged: (String? value) {
                                      setState(() {
                                        levelSelect = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 48,
                                      width: double.infinity,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                )))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                        child: Row(
                          children: [
                            Text(
                              'คำอธิบายตัวเอง',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: details,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
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
                                      vertical: 15, horizontal: 12),
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
                                maxLines: 3,

                                // onSaved: (String email) {
                                //   profile.email = email;
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginScreen()));
                            },
                            child: Text(
                              'สมัครสมาชิก',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
