// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'dart:convert';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/add.dart';
import 'package:finalmo/screen/gang/admin_of.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:finalmo/screen/gang/review.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GangOwnerDetail extends StatefulWidget {
  final club;
  const GangOwnerDetail({@required this.club, Key? key}) : super(key: key);

  @override
  State<GangOwnerDetail> createState() => _GangOwnerDetailState();
}

class _GangOwnerDetailState extends State<GangOwnerDetail>
    with TickerProviderStateMixin {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  bool loading = true;
  bool followStatus = false;
  var clubInfo = {};
  var rating = '';

  var reviewlist = {};
  List<Map<String, dynamic>> activeEventList = [];
  List<Map<String, dynamic>> inActiveEventList = [];
  var follower = '';

  @override
  void initState() {
    super.initState();
    initSharedPref();
    print(widget.club);
    getClubDetail(widget.club);
    getReview(widget.club);
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

  void getClubDetail(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getClub', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        clubInfo = jsonResponse['club'];
      });
      print("clubInfo: $clubInfo");
      if (clubInfo['follower'].contains(username)) {
        print('$username found in the list.');
        setState(() {
          followStatus = true;
        });
      }

      int count = 0;
      for (var event in jsonResponse['club']['follower']) {
        count++;
      }
      setState(() {
        follower = count.toString();
      });
      print(follower);

      getEvent(clubInfo['event_id']);
    }
  }

  void onFollow() async {
    var regBody = {"userName": username, "clubId": clubInfo['_id']};

    var response = await http.post(Uri.parse(AddFollow),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print('Follow:');
    print(jsonResponse['status']);
    if (jsonResponse['status']) {
      setState(() {
        followStatus = true;
      });
    }
  }

  void onUnFollow() async {
    var regBody = {"userName": username, "clubId": clubInfo['_id']};

    var response = await http.delete(Uri.parse(unFollow),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print('UnFollow:');
    print(jsonResponse['delete']);
    if (jsonResponse['delete']) {
      setState(() {
        followStatus = false;
      });
    }
  }

  void getEvent(eventId) async {
    var queryParameters = {
      'ownIdList': eventId,
    };

    var uri = Uri.http(getUrl, '/getOwnEvent', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      // print(jsonResponse['data']);
      for (var event in jsonResponse['data']) {
        if (event['active']) {
          activeEventList.add(event);
        } else {
          inActiveEventList.add(event);
        }
      }
      print('Active Events: $activeEventList');
      print('Inactive Events: $inActiveEventList');
      setState(() {
        loading = false;
      });
    }
  }

  Future<String> getReview(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getReviewList', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        reviewlist = jsonResponse;
        averageScore(reviewlist);
      });
    }

    setState(() {
      loading = false;
    });
    return rating;
  }

  void averageScore(reviewlist) {
    int sum = 0;
    int count = reviewlist['success'].length;

    for (var value in reviewlist['success']) {
      int score = value['score'];
      sum += score;
    }

    double average = count > 0 ? sum / count : 0;
    String formattedAverage = average.toStringAsFixed(1);
    print('Average Score: $formattedAverage');
    rating = formattedAverage;
  }

  void deleteClub(id, clubname) async {
    // print(id);
    var regBody = {"_id": id, "clubname": clubname};
    print(regBody);
    var response = await http.delete(Uri.parse(delClub),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
    } else {
      print('SDadw');
    }
  }

  Future<bool> _onBackPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TabBarViewMyEvent()),
    );

    // Handle whether to allow back navigation or not
    return true; // Return true if you want to allow back navigation, false otherwise
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onBackPressed() ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "ข้อมูลกลุ่มจัดก๊วน",
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
            padding: EdgeInsets.all(20),
            child: loading
                ? CircularProgressIndicator()
                : Column(children: [
                    Row(
                      children: [
                        Text(
                          clubInfo['clubname'],
                          style: TextStyle(
                            color: Color(0xFF013C58),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 20),
                        if (username != clubInfo['owner']) ...[
                          if (followStatus) ...[
                            SizedBox(
                              height: 30,
                              width: 110,
                              child: TextButton(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 15,
                                          color: Color(0xFF02D417),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'ติดตามแล้ว',
                                          style: TextStyle(
                                            color: Color(0xFF29C14A),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ]),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFF29C14A)),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () => {onUnFollow()}),
                            )
                          ] else ...[
                            SizedBox(
                              height: 30,
                              child: TextButton(
                                  child: Text(
                                    'ติดตาม',
                                    style: TextStyle(
                                      color: Color(0xFF484848),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFF484848)),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () => {onFollow()}),
                            )
                          ]
                        ] else if (username == clubInfo['owner']) ...[
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: new Icon(Icons.delete),
                                          title: new Text('ลบกลุ่มกิจกรรม'),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'ลบกลุ่มกิจกรรม'),
                                                content: const Text(
                                                    'ต้องการลบกลุ่มนี้ใช่หรือไม่'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('ยกเลิก'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => {
                                                      deleteClub(
                                                          clubInfo['_id'],
                                                          clubInfo['clubname']),
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                TabBarViewMyEvent()),
                                                      ),
                                                    },
                                                    child: const Text('ยืนยัน'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        // DialogExample(),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.expand_more,
                                  color: Color(0xFFF5A201),
                                  size: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 230, 179),
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.admin_panel_settings,
                                color: Color(0xFFF5A201),
                                size: 18.0,
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'เจ้าของ',
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            Text(
                              clubInfo['owner'],
                              style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    if (clubInfo['owner'] == username ||
                        clubInfo['admin'].contains(username)) ...[
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 230, 179),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.manage_accounts,
                                  color: Color(0xFFF5A201),
                                  size: 18.0,
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: Color(0xFF013C58),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              Row(
                                children: List<Widget>.generate(
                                  clubInfo['admin'].length,
                                  (index) => Text(
                                    clubInfo['admin'][index] + ", ",
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Color(0xFF929292),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AdiminOf(
                                                    club:
                                                        clubInfo['clubname'])));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: Color(0xFFF5A201),
                                      size: 18.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.10999999940395355),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              follower,
                              style: TextStyle(
                                color: Color(0xFF013C58),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ผู้ติดตาม',
                              style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.black.withOpacity(0.10999999940395355),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReviewScreen(
                                          club: widget.club,
                                          owner: clubInfo[
                                              'owner'])), // เปลี่ยนเป็นชื่อหน้าหาก๊วนจริงๆ ของคุณ
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    rating,
                                    style: TextStyle(
                                      color: Color(0xFF013C58),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        'รีวิว',
                                        style: TextStyle(
                                          color: Color(0xFF929292),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFF929292),
                                        size: 14.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 20),
                    // LinearProgressIndicator(
                    //   value: 5,
                    //   semanticsLabel: 'Linear progress indicator',
                    // ),
                    ExpansionTile(
                      title: Text(
                          'เปิดให้เข้าร่วมแล้ว (${activeEventList.length})'),
                      textColor: Color(0xFF29C14A),
                      collapsedTextColor: Color(0xFF29C14A),
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      children: activeEventList.map<Widget>((items) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GangDetail(
                                            id: items['_id'],
                                            club: clubInfo['clubname'],
                                          )));
                            },
                            child: Material(
                              elevation: 5.0,
                              shadowColor: Color.fromARGB(192, 0, 0, 0),
                              borderRadius: new BorderRadius.circular(30),
                              child: Container(
                                height: 160,
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: clubInfo['owner'] == username &&
                                              items['pending'].length > 0
                                          ? Color(0xFFFF5B5B)
                                          : clubInfo['owner'] == username &&
                                                  items['pending'].length < 0
                                              ? Color(0xFFFFA201)
                                              : Color(0xFFFFA201),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items['club'],
                                          style: TextStyle(
                                            color: Color(0xFF013C58),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            height: 0,
                                          ),
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xFFFF3333),
                                            size: 20.0,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              'สนามเอสแอนด์เอ็ม จรัญ13 (12 กม.)',
                                              style: TextStyle(
                                                color: Color(0xFF929292),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Color(0xFF013C58),
                                            size: 20.0,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                              style: TextStyle(
                                                color: Color(0xFF929292),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        if (items['level'] != null &&
                                            items['level'].isNotEmpty) ...[
                                          Row(
                                            children: [
                                              for (int i = 0;
                                                  i < items['level'].length;
                                                  i++)
                                                Container(
                                                  margin: i > 0
                                                      ? EdgeInsets.only(
                                                          left: 10)
                                                      : EdgeInsets.zero,
                                                  height: 22,
                                                  width: 22,
                                                  decoration: BoxDecoration(
                                                    color: items['level'][i] ==
                                                            'N'
                                                        ? Color(
                                                            0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                        : items['level'][i] ==
                                                                'S'
                                                            ? Color(0x5B009020)
                                                            : items['level']
                                                                        [i] ==
                                                                    'P'
                                                                ? Color(
                                                                    0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        222,
                                                                        234,
                                                                        255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7), // กำหนด radius ให้กรอบสี่เหลี่ยม
                                                    border: Border.all(
                                                      width: 2,
                                                      color: items['level']
                                                                  [i] ==
                                                              'N'
                                                          ? Color(
                                                              0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                          : items['level'][i] ==
                                                                  'S'
                                                              ? Color(
                                                                  0xFF00901F)
                                                              : items['level']
                                                                          [i] ==
                                                                      'P'
                                                                  ? Color(
                                                                      0xFFFC7FFF)
                                                                  : Color(
                                                                      0xFFFC7FFF),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      items['level'][i],
                                                      style: TextStyle(
                                                        color: items['level']
                                                                    [i] ==
                                                                'N'
                                                            ? Color(
                                                                0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                            : items['level']
                                                                        [i] ==
                                                                    'S'
                                                                ? Color(
                                                                    0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                : items['level']
                                                                            [
                                                                            i] ==
                                                                        'P'
                                                                    ? Color(
                                                                        0xFFFC7FFF)
                                                                    : Color(
                                                                        0xFFFC7FFF),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                        SizedBox(height: 7),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.stars,
                                              color: Color.fromARGB(
                                                  255, 255, 154, 3),
                                              size: 20.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                rating,
                                                style: TextStyle(
                                                  color: Color(0xFF929292),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Spacer(),
                                        if (clubInfo['owner'] == username) ...[
                                          if (items['pending'].length > 0) ...[
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xFFFF5B5B),
                                                  size: 36.0,
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Text(
                                                  "กำลังรอ" +
                                                      "  " +
                                                      items['pending']
                                                          .length
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Color(0xFFFF5B5B),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ] else ...[
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color.fromARGB(
                                                      255, 255, 154, 3),
                                                  size: 36.0,
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ] else ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color.fromARGB(
                                                    255, 255, 154, 3),
                                                size: 36.0,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    ExpansionTile(
                      title: Text(
                          'ยังไม่เปิดให้เข้าร่วม (${inActiveEventList.length})'),
                      textColor: Color(0xFF929292),
                      collapsedTextColor: Color(0xFF929292),
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      children: inActiveEventList.map<Widget>((items) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GangDetail(
                                            id: items['_id'],
                                            club: clubInfo['clubname'],
                                          )));
                            },
                            child: Material(
                              elevation: 5.0,
                              shadowColor: Color.fromARGB(192, 0, 0, 0),
                              borderRadius: new BorderRadius.circular(30),
                              child: Container(
                                height: 160,
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 116, 116, 116)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          items['club'],
                                          style: TextStyle(
                                            color: Color(0xFF013C58),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            height: 0,
                                          ),
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xFFFF3333),
                                            size: 20.0,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              'สนามเอสแอนด์เอ็ม จรัญ13 (12 กม.)',
                                              style: TextStyle(
                                                color: Color(0xFF929292),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Color(0xFF013C58),
                                            size: 20.0,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              'จันทร์ , พุธ , เสาร์ 19.00 - 22.00 น.',
                                              style: TextStyle(
                                                color: Color(0xFF929292),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        if (items['level'] != null &&
                                            items['level'].isNotEmpty) ...[
                                          Row(
                                            children: [
                                              for (int i = 0;
                                                  i < items['level'].length;
                                                  i++)
                                                Container(
                                                  margin: i > 0
                                                      ? EdgeInsets.only(
                                                          left: 10)
                                                      : EdgeInsets.zero,
                                                  height: 22,
                                                  width: 22,
                                                  decoration: BoxDecoration(
                                                    color: items['level'][i] ==
                                                            'N'
                                                        ? Color(
                                                            0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                        : items['level'][i] ==
                                                                'S'
                                                            ? Color(0x5B009020)
                                                            : items['level']
                                                                        [i] ==
                                                                    'P'
                                                                ? Color(
                                                                    0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        222,
                                                                        234,
                                                                        255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7), // กำหนด radius ให้กรอบสี่เหลี่ยม
                                                    border: Border.all(
                                                      width: 2,
                                                      color: items['level']
                                                                  [i] ==
                                                              'N'
                                                          ? Color(
                                                              0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                          : items['level'][i] ==
                                                                  'S'
                                                              ? Color(
                                                                  0xFF00901F)
                                                              : items['level']
                                                                          [i] ==
                                                                      'P'
                                                                  ? Color(
                                                                      0xFFFC7FFF)
                                                                  : Color(
                                                                      0xFFFC7FFF),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      items['level'][i],
                                                      style: TextStyle(
                                                        color: items['level']
                                                                    [i] ==
                                                                'N'
                                                            ? Color(
                                                                0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                            : items['level']
                                                                        [i] ==
                                                                    'S'
                                                                ? Color(
                                                                    0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                : items['level']
                                                                            [
                                                                            i] ==
                                                                        'P'
                                                                    ? Color(
                                                                        0xFFFC7FFF)
                                                                    : Color(
                                                                        0xFFFC7FFF),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                        SizedBox(height: 7),
                                        Row(children: [
                                          Icon(
                                            Icons.stars,
                                            color: Color.fromARGB(
                                                255, 116, 116, 116),
                                            size: 20.0,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              rating,
                                              style: TextStyle(
                                                color: Color(0xFF929292),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Color.fromARGB(
                                                  255, 116, 116, 116),
                                              size: 36.0,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (username == clubInfo['owner']) ...[
                      SizedBox(
                        height: 60,
                        child: TextButton(
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Add(club: clubInfo['clubname'])))
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Color(0xFF929292),
                                size: 28.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'เพิ่มกิจกรรม',
                                style: TextStyle(
                                    color: Color(0xFF929292),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFCFCFCF)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )
                    ]
                  ]),
          )),
        ),
      ),
    );
  }
}
