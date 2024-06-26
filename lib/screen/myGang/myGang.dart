import 'package:finalmo/screen/myGang/myGangFollow.dart';
import 'package:finalmo/screen/myGang/myGangJoin.dart';
import 'package:finalmo/screen/myGang/myGangOwner.dart';
import 'package:flutter/material.dart';

class MyGang extends StatefulWidget {
  final numpage;
  const MyGang({this.numpage, Key? key}) : super(key: key);

  @override
  State<MyGang> createState() => _MyGangState();
}

class _MyGangState extends State<MyGang> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.numpage,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'กลุ่มของฉัน',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          bottom: const TabBar(
            unselectedLabelColor: Color(0xFF8BA6B3),
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.favorite),
                text: 'ที่ติดตาม',
              ),
              Tab(
                icon: Icon(Icons.how_to_reg),
                text: 'ที่เข้าร่วม',
              ),
              Tab(
                icon: Icon(Icons.admin_panel_settings),
                text: 'ที่ดูแล',
              ),
            ],
          ),
          backgroundColor: Color(0xFF00537A),
        ),
        body: const TabBarView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [MyGangFollow()],
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [MyGangJoin()],
                  ),
                )),
            MyGangOwner()
          ],
        ),
      ),
    );
  }
}
