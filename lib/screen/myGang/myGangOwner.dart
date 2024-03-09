// ignore_for_file: prefer_const_constructors

import 'package:finalmo/postModel.dart';
import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:finalmo/screen/gang/gangOwnerDetail.dart';
import 'package:finalmo/screen/myGang/addclub.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGangOwner extends StatefulWidget {
  const MyGangOwner({super.key});

  @override
  State<MyGangOwner> createState() => _MyGangOwnerState();
}

class _MyGangOwnerState extends State<MyGangOwner> {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  List<ClubList> clublist = [];
  var jsonResponse;
  bool status = false;
  bool loading = false;

  void initState() {
    // TODO: implement initState
    initializeState();

    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // userId = jwtDecodedToken['_id'];
  }

  void initializeState() async {
    await initSharedPref();
    getClubList();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  void getClubList() async {
    print(username);
    setState(() {
      loading = true;
    });
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getOwnerClub', queryParameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);

      print(jsonResponse);

      // jsonResponse['success'].forEach((value) => clublist.add(ClubList(
      //       owner: value['owner'],
      //       follower: value['follower'],
      //       clubname: value['clubname'],
      //       admin: value['admin'],
      //       eventId: value['event_id'],
      //     )));
      status = true;

      // print(jsonResponse);
      // print(jsonResponse.eventlist.toString());
      setState(() {
        loading = false;
      });
    } else {
      status = true;

      print(response.statusCode);
    }
    // items = jsonResponse['clublistdata'];
    // List<EventList> eventlist = [],

    // print(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Container(
                  child: !status
                      ? Text("Error: ")
                      : Column(
                          children: jsonResponse['data'].map<Widget>(
                            (items) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GangOwnerDetail(
                                                    club: items['clubname'])));
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Color.fromARGB(192, 0, 0, 0),
                                    borderRadius: new BorderRadius.circular(30),
                                    child: Container(
                                      height: 110,
                                      width: double.infinity,
                                      decoration: ShapeDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 2,
                                              color: Color(0xFFF5A201)),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              // ignore: prefer_const_constructors
                                              Text(
                                                items['clubname'],
                                                style: TextStyle(
                                                  color: Color(0xFF013C58),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  height: 0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(children: [
                                                Icon(
                                                  Icons.admin_panel_settings,
                                                  color: Color.fromARGB(
                                                      255, 255, 154, 3),
                                                  size: 20.0,
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    items['owner'],
                                                    style: TextStyle(
                                                      color: Color(0xFF929292),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                  Icons.stars,
                                                  color: Color.fromARGB(
                                                      255, 255, 154, 3),
                                                  size: 20.0,
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    '4.3',
                                                    style: TextStyle(
                                                      color: Color(0xFF929292),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.settings,
                                                    color: Color.fromARGB(
                                                        255, 255, 154, 3),
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
                            },
                          ).toList(),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Color(0xFF515151),
                          builder: (BuildContext context) {
                            return AddClub(
                              username: username,
                            ); // เรียกใช้ AddClubModal ที่เราสร้างไว้
                          },
                        );
                      },
                      tooltip: 'Addclub',
                      child: const Icon(Icons.add),
                      shape: CircleBorder(), // เปลี่ยนรูปร่างเป็นวงกลม
                      elevation: 8,
                      backgroundColor: Color(0xFFF5A201),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
