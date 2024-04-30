import 'dart:convert';

import 'package:finalmo/screen/Event/gangDetail.dart';
import 'package:finalmo/screen/Event/gangOwnerDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdiminOf extends StatefulWidget {
  final club;
  const AdiminOf({@required this.club, Key? key}) : super(key: key);

  @override
  State<AdiminOf> createState() => _AdiminOfState();
}

class _AdiminOfState extends State<AdiminOf> {
  // String dropdownvalueOwner = 'เจ้าของก๊วน';
  String dropdownvalueAdmin = 'Admin';
  String dropdownvalueMember = 'สมาชิก';

  var items = [
    'Admin',
    'สมาชิก',
  ];
  List<Map<String, String>> transformeRole = [];

  var clubdata;
  var eventeach = {};
  List<Map<String, String>> roleUserList = [];
  var imageList = {};
  bool loading = true;

  void initState() {
    super.initState();
    initSharedPref();
    getClubDetail(widget.club);
  }

  void getClubDetail(clubname) async {
    var queryParameters = {'clubname': clubname};

    var uri = Uri.http(getUrl, '/getClub', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        clubdata = jsonResponse['club'];

        transformeRole.add({'role': 'owner', 'name': clubdata['owner']});
        var adminNames =
            Set<String>(); // เพิ่มตัวแปรเพื่อเก็บชื่อ admin เพื่อตรวจสอบซ้ำ
        clubdata['admin'].forEach((admin) async {
          transformeRole.add({'role': 'admin', 'name': admin});
          adminNames.add(admin); // เพิ่มชื่อ admin เข้ากลุ่มเพื่อตรวจสอบซ้ำ
        });

        clubdata['follower'].forEach((follower) async {
          // เพิ่มเฉพาะ 'follower' ที่ไม่เป็น 'admin' หรือไม่มีชื่อซ้ำกับ 'admin'

          if (!adminNames.contains(follower)) {
            transformeRole.add({'role': 'follower', 'name': follower});
          }
        });

        // roleUserList = transformeRole;

        print("transformeRole: $transformeRole");
      });
      for (var admin in clubdata['admin']) {
        imageList[admin] = await getUserImg(admin);
      }

      for (var follower in clubdata['follower']) {
        imageList[follower] = await getUserImg(follower);
      }
      imageList[clubdata['owner']] = await getUserImg(clubdata['owner']);
      print("Image: $imageList");
      print("clubdata: $clubdata");
      setState(() {
        loading = false;
      });
    }
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  Future<void> roleGetAdmin(name) async {
    var regBody = {"userName": name, "clubId": clubdata['_id']};

    var response = await http.post(Uri.parse(assingAdmin),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    // print(jsonResponse['status']);
    if (jsonResponse['status']) {
      setState(() {
        int userIndex =
            transformeRole.indexWhere((user) => user['name'] == name);
        transformeRole[userIndex]['role'] = 'admin';
      });
      print(transformeRole);
    }
  }

  Future<void> roleUnGetAdmin(name) async {
    var regBody = {"userName": name, "clubId": clubdata['_id']};

    var response = await http.delete(Uri.parse(unAssingAdmin),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);

    // print(jsonResponse['delete']);
    if (jsonResponse['delete']) {
      setState(() {
        int userIndex =
            transformeRole.indexWhere((user) => user['name'] == name);
        transformeRole[userIndex]['role'] = 'follower';
      });
    }
  }

  Future<String> getUserImg(param) async {
    var queryParameters = {
      'userName': param,
    };
    var uri = Uri.http(getUrl, '/getUserImage', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      return jsonResponse['data'];
    } else {
      return "";
    }
  }

  Future<bool> _onBackPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GangOwnerDetail(club: widget.club)),
    );
    print("ddddddddddddddddddddddddddddddddddd");

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
                "Admin",
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
              padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
              child: Column(
                children: transformeRole.map<Widget>((item) {
                  String dropdownvalue;
                  if (item['role'] == 'follower') {
                    dropdownvalue = dropdownvalueMember;
                  } else {
                    dropdownvalue = dropdownvalueAdmin;
                  }

                  return Padding(
                    padding: EdgeInsetsDirectional.all(5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            if (imageList[item['name']] != "") ...[
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(imageList[item['name']]),
                              )
                            ] else ...[
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/images/user_default.png'),
                              )
                            ],
                            SizedBox(width: 25),
                            Text(
                              item['name'] ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Spacer(),
                            if (item['role'] != 'owner') ...[
                              Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 40,
                                          padding: EdgeInsets.all(5.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              elevation: 0,
                                              value: dropdownvalue,
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 25,
                                              ),
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items,
                                                    style: TextStyle(
                                                      color: Color(0xFF013C58),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  if (item['role'] ==
                                                      'follower') {
                                                    dropdownvalue = newValue!;
                                                    roleGetAdmin(item['name']);
                                                  } else {
                                                    dropdownvalue = newValue!;
                                                    roleUnGetAdmin(
                                                        item['name']);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: EdgeInsets.only(right: 15, top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 40,
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'เจ้าของ',
                                            style: TextStyle(
                                              color: Color(0xFF013C58),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.black.withOpacity(0.10999999940395355),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ))),
    );
  }
}
