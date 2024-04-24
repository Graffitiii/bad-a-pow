import 'package:finalmo/screen/add.dart';
import 'package:finalmo/screen/Event/findGang.dart';
import 'package:finalmo/screen/home.dart';
import 'package:finalmo/screen/myGang/myGang.dart';
import 'package:finalmo/screen/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

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
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),

              Container(
                  child: MyGang(
                numpage: 0,
              )),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewFindEvent extends StatefulWidget {
  final search;
  TabBarViewFindEvent({
    Key? key,
    this.search,
  }) : super(key: key);

  @override
  State<TabBarViewFindEvent> createState() => _TabBarViewFindEventState();
}

class _TabBarViewFindEventState extends State<TabBarViewFindEvent> {
  late SharedPreferences prefs;
  var myToken;
  var searchKey;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      searchKey = widget.search;
    });
    initSharedPref();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => setSearch());
  }

  void setSearch() {
    setState(() {
      searchKey = null;
    });
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
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
      home: DefaultTabController(
        length: 4,
        initialIndex: 1,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              if(searchKey != null) ...[
                Container(child: FindGang(search: searchKey,)),
              ]else ...[
                Container(child: FindGang()),
              ],
                
              
              

              Container(
                  child: MyGang(
                numpage: 0,
              )),
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
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
      home: DefaultTabController(
        length: 4,
        initialIndex: 2,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),

              Container(
                  child: MyGang(
                numpage: 0,
              )),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewMyEvent1 extends StatefulWidget {
  const TabBarViewMyEvent1({super.key});

  @override
  State<TabBarViewMyEvent1> createState() => _TabBarViewMyEvent1State();
}

class _TabBarViewMyEvent1State extends State<TabBarViewMyEvent1> {
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
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
      home: DefaultTabController(
        length: 4,
        initialIndex: 2,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),

              Container(
                  child: MyGang(
                numpage: 1,
              )),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewMyEvent2 extends StatefulWidget {
  const TabBarViewMyEvent2({super.key});

  @override
  State<TabBarViewMyEvent2> createState() => _TabBarViewMyEvent2State();
}

class _TabBarViewMyEvent2State extends State<TabBarViewMyEvent2> {
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
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
      home: DefaultTabController(
        length: 4,
        initialIndex: 2,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),

              Container(
                  child: MyGang(
                numpage: 2,
              )),
              Container(child: Profile()),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarViewProfile extends StatefulWidget {
  final sos;
  const TabBarViewProfile({this.sos, super.key});

  @override
  State<TabBarViewProfile> createState() => _TabBarViewProfileState();
}

class _TabBarViewProfileState extends State<TabBarViewProfile> {
  late SharedPreferences prefs;
  var myToken;
  var optab;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      optab = widget.sos;
    });

    super.initState();
    initSharedPref();

    SchedulerBinding.instance.addPostFrameCallback((_) => showMBsheet());
  }

  void showMBsheet() {
    print('Finish');
    setState(() {
      optab = null;
    });
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
      theme: ThemeData(primarySwatch: Colors.blueGrey, fontFamily: 'Noto'),
      home: DefaultTabController(
        length: 4,
        initialIndex: 3,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              Container(child: HomePage(token: myToken)),
              // Container(child: FindGang()),
              Container(child: FindGang()),

              Container(
                  child: MyGang(
                numpage: 0,
              )),
              if (optab != null) ...[
                Container(child: Profile(a: widget.sos)),
              ] else ...[
                Container(child: Profile(a: null)),
              ]
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
          text: "หากิจกรรม",
          icon: Icon(Icons.business),
        ),
        Tab(
          text: "กลุ่มของฉัน",
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
