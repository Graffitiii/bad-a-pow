import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';

class SettingProfile extends StatefulWidget {
  const SettingProfile({super.key});

  @override
  State<SettingProfile> createState() => _SettingProfileState();
}

class _SettingProfileState extends State<SettingProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "โปรไฟล์",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
        // elevation: 0,
        // toolbarHeight: 10,
      ),
      body: Setting(),
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: CircleAvatar(
                maxRadius: 55,
                backgroundImage: AssetImage('assets/images/profile2.jpg'),
              ),
            ),
            Column(
              children: [
                Text(
                  'TTamonwan233',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'sfedjsif sfjsjef',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              icon: const Icon(Icons.edit_square),
              tooltip: 'การตั้งค่า',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Profile()));
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              child: Row(
                children: [
                  Text(
                    'เพศ',
                    style: TextStyle(
                      color: Color(0xFF013C58),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    'หญิง',
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              child: Row(
                children: [
                  Text(
                    'อายุ',
                    style: TextStyle(
                      color: Color(0xFF013C58),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    'ไม่ระบุ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 100),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              child: Row(
                children: [
                  Text(
                    'ระดับฝีมือ',
                    style: TextStyle(
                      color: Color(0xFF013C58),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 60),
                  Text(
                    'S',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'อยู่ประจำสนามแบดมินตันฐานทอง ทุกวันศุกร์ เพิ่งหัดมาเล่นได้ไม่นานค่ะ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ))));
  }
}
