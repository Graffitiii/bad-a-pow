import 'package:finalmo/screen/add.dart';
import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/home.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarViewBottom extends StatefulWidget {
  const TabBarViewBottom({super.key});

  @override
  State<TabBarViewBottom> createState() => _TabBarViewBottomState();
}

class _TabBarViewBottomState extends State<TabBarViewBottom> {
  late SharedPreferences prefs;
  var myToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    print(myToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),
              Container(child: Add()),
              Container(child: MyGang()),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewFindEvent extends StatefulWidget {
  const TabBarViewFindEvent({super.key});

  @override
  State<TabBarViewFindEvent> createState() => _TabBarViewFindEventState();
}

class _TabBarViewFindEventState extends State<TabBarViewFindEvent> {
  late SharedPreferences prefs;
  var myToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    print(myToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        initialIndex: 1,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),
              Container(child: Add()),
              Container(child: MyGang()),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewMyEvent extends StatefulWidget {
  const TabBarViewMyEvent({super.key});

  @override
  State<TabBarViewMyEvent> createState() => _TabBarViewMyEventState();
}

class _TabBarViewMyEventState extends State<TabBarViewMyEvent> {
  late SharedPreferences prefs;
  var myToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    print(myToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        initialIndex: 3,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),
              Container(child: Add()),
              Container(child: MyGang()),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewProfile extends StatefulWidget {
  const TabBarViewProfile({super.key});

  @override
  State<TabBarViewProfile> createState() => _TabBarViewProfileState();
}

class _TabBarViewProfileState extends State<TabBarViewProfile> {
  late SharedPreferences prefs;
  var myToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    print(myToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        initialIndex: 4,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),
              Container(child: Add()),
              Container(child: MyGang()),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget menu() {
  return Container(
    // color: Color.fromARGB(255, 224, 224, 224),
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: Color(0xFFDFDFDF)),
      ),
      color: Color.fromARGB(255, 255, 255, 255),
    ),
    child: TabBar(
      labelColor: Color(0xFFF5A201),
      unselectedLabelColor: Color(0xFF013C58),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(3.0),
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
            Icons.add_box,
            size: 40,
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
