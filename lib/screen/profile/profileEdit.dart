import 'package:finalmo/config.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/profile/Owner_Apply.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  List<String> gender = ['ชาย', 'หญิง', 'ไม่ระบุ'];
  List<String> showAge = ['แสดง', 'ไม่แสดง'];
  List<String> level = ['N', 'S', 'P'];
  String? genderSelect;
  String? showAgeSelect;
  String? levelSelect;
  @override
  void initState() {
    super.initState();
    initSharedPref();
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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              items: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // กำหนดให้เป็นรูปร่างวงกลม
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 230.0,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
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
                      'TTamonwan233',
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
                                // controller: details,
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
