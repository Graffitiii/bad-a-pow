import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:finalmo/screen/profile/Owner_Apply.dart';
import 'package:flutter/material.dart';

class TabBarViewBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: FindGang()),
              Container(child: FindGang()),
              Container(child: MyGang()),
              Container(child: MyGang()),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Color(0xFF013C58),
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Color(0xFFF5A201),
        tabs: [
          Tab(
            text: "Home",
            icon: Icon(Icons.home),
          ),
          Tab(
            text: "หาก๊วน",
            icon: Icon(Icons.business),
          ),
          Tab(
            text: " ",
            icon: Icon(
              Icons.home_rounded,
              size: 35,
            ),
          ),
          Tab(
            text: "ก๊วนของฉัน",
            icon: Icon(Icons.school),
          ),
          Tab(
            text: "โปรไฟล์",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
