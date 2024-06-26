import 'package:finalmo/screen/Event/gangOwnerDetail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalmo/config.dart';

class MyGangFollow extends StatefulWidget {
  const MyGangFollow({super.key});

  @override
  State<MyGangFollow> createState() => _MyGangFollowState();
}

class _MyGangFollowState extends State<MyGangFollow> {
  late String username;
  late SharedPreferences prefs;
  var myToken;
  List clubList = [];
  var jsonResponse;
  bool loading = true;

  var reviewlist = {};
  Map<String, String> review = {};

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    await initSharedPref();
    getFollowList();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  void getFollowList() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getFollowClub', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        clubList = jsonResponse['data'];
      });
      print(clubList);
      // print(clublist);
      List<Future> reviewFutures = [];
      for (var club in jsonResponse['data']) {
        // Call getReview for each club and store the future
        reviewFutures.add(getReview(club['clubname']));
      }

      await Future.wait(reviewFutures);

      setState(() {
        loading = false;
      });
    } else {}
  }

  Future<void> getReview(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getReviewList', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        reviewlist = jsonResponse;
        // print(averageScore(reviewlist));
        review[clubname] = averageScore(reviewlist);
      });
    }

    setState(() {
      loading = false;
    });
  }

  String averageScore(reviewlist) {
    var rating = '';
    int sum = 0;
    int count = reviewlist['success'].length;

    for (var value in reviewlist['success']) {
      int score = value['score'];
      sum += score;
    }

    double average = count > 0 ? sum / count : 0;
    String formattedAverage = average.toStringAsFixed(1);
    // print('Average Score: $formattedAverage');
    rating = formattedAverage;
    return rating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: clubList.map<Widget>((items) {
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          GangOwnerDetail(club: items['clubname'])));
            },
            child: Material(
              elevation: 5.0,
              shadowColor: Color.fromARGB(192, 0, 0, 0),
              borderRadius: new BorderRadius.circular(30),
              child: Container(
                height: 110,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFFF5A201)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Color.fromARGB(255, 255, 154, 3),
                            size: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              items['owner'],
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
                            Icons.stars,
                            color: Color.fromARGB(255, 255, 154, 3),
                            size: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              review[items['clubname']] ?? '',
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
                              color: Color.fromARGB(255, 255, 154, 3),
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
    );
  }
}
