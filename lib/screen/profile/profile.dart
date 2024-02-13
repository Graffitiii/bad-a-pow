import 'package:finalmo/screen/login.dart';
import 'package:finalmo/screen/profile/profile_setting.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'การตั้งค่า',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: new Icon(Icons.manage_accounts),
                        title: new Text('การตั้งค่าโปรไฟล์'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SettingProfile()));
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.logout),
                        title: new Text('ออกจากระบบ'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.info),
                        title: new Text('เกี่ยวกับ'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('เกี่ยวกับ'),
                                ),
                                body: const Center(
                                  child: Text(
                                    'This is the next page',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            },
                          ));
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.supervisor_account),
                        title: new Text('สมัครเป็นผู้จัดก๊วน'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('สมัครเป็นผู้จัดก๊วน'),
                                ),
                                body: const Center(
                                  child: Text(
                                    'This is the next page',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              );
                            },
                          ));
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: CarouselSliderExample(),
    );
  }
}

class CarouselSliderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // กำหนดให้เป็นรูปร่างวงกลม
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile4.jpg'),
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
                        fontFamily: 'Inter',
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
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(
                          children: [
                            Text(
                              'เพศ',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 16,
                                fontFamily: 'Inter',
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
                                fontFamily: 'Inter',
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
                            Text(
                              'อายุ',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 16,
                                fontFamily: 'Inter',
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
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            SizedBox(width: 100),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(
                          children: [
                            Text(
                              'ระดับฝีมือ',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 16,
                                fontFamily: 'Inter',
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
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            SizedBox(width: 60),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(
                          children: [
                            Text(
                              'คำอธิบายตัวเอง',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 16,
                                fontFamily: 'Inter',
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
                              child: Text(
                                'อยู่ประจำสนามแบดมินตันฐานทอง ทุกวันศุกร์ เพิ่งหัดมาเล่นได้ไม่นานค่ะ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
