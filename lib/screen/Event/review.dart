import 'package:finalmo/screen/Event/addcomment.dart';
import 'package:finalmo/screen/Event/gangOwnerDetail.dart';
import 'package:finalmo/screen/add.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  final club, owner;
  const ReviewScreen({this.club, this.owner, super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var jsonResponse;
  bool status = true;
  bool loading = true;
  bool reviewAllow = false;

  var username = '';
  // late String username;
  late SharedPreferences prefs;
  var myToken;

  var reviewlist = {};
  var imageList = {};

  @override
  void initState() {
    initializeState();
    super.initState();
    print(widget.club);
    print(widget.owner);
  }

  void initializeState() async {
    await initSharedPref();
    getReview(widget.club);
    getHistory();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
    print("ชื่อผู้ใช้: " + username);
  }

  void getReview(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getReviewList', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        reviewlist = jsonResponse;
        AverageScore();
      });
      print(reviewlist);
    }

    for (var reviews in reviewlist['success']) {
      if (reviews['userName'] != "ผู้ใช้") {
        imageList[reviews['userName']] = await getUserImg(reviews['userName']);
      }
    }

    print(imageList);

    setState(() {
      loading = false;
    });
  }

  void getHistory() async {
    var queryParameters = {
      'username': username,
    };

    var uri = Uri.http(getUrl, '/findHistory', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      for (var item in jsonResponse['result']) {
        print(item['clubname']);
        if (item['clubname'] == widget.club) {
          setState(() {
            reviewAllow = true;
          });
          break;
        }
      }
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

  String formattingDate(start) {
    initializeDateFormatting('th', null);

    DateTime eventStart = DateTime.parse(start);

    DateTime thaiDateStartTime = eventStart.add(Duration(hours: 7));

    // Convert year from Gregorian calendar (AD) to Buddhist calendar (BE)
    int buddhistYearStart = thaiDateStartTime.year + 543;

    String formattedDateTime =
        DateFormat('d MMMM yyyy H:mm' + ' น.', 'th').format(thaiDateStartTime);

    // Format with Buddhist year (BE)
    formattedDateTime = formattedDateTime.replaceFirst(
        thaiDateStartTime.year.toString(), buddhistYearStart.toString());

    return formattedDateTime;
  }

  String AverageScore() {
    int sum = 0;
    int count = reviewlist['success'].length;

    for (var value in reviewlist['success']) {
      int score = value['score'];
      sum += score;
    }

    double average = count > 0 ? sum / count : 0;
    String averages = average.toStringAsFixed(1);
    print('Average Score: $averages');

    return averages;
  }

  Future<bool> _onBackPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GangOwnerDetail(club: widget.club)),
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
              'รีวิว',
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
        bottomNavigationBar: reviewAllow
            ? Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1.0,
                      color: Color.fromARGB(255, 153, 153, 153),
                    ),
                  ),
                ),
                height: 70,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              child: Text(
                                'เพิ่มความคิดเห็น',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                elevation: 2,
                                backgroundColor: const Color(0xFF013C58),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCommentScreen(
                                      club: widget.club,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        body: SafeArea(
          left: false,
          right: false,
          child: SingleChildScrollView(
            child: loading
                ? CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                    child: !status
                        ? Text("Error: ")
                        : reviewlist['success']
                                .isEmpty // ตรวจสอบว่ารายการรีวิวว่างเปล่าหรือไม่
                            ? Center(child: Text("ยังไม่มีรีวิว"))
                            : Column(
                                children:
                                    reviewlist['success'].map<Widget>((items) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFD9D9D9)),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 15, 5, 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                if (items['userName'] ==
                                                    "ผู้ใช้") ...[
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/user_default.png'),
                                                  )
                                                ] else ...[
                                                  if (imageList[
                                                          items['userName']] !=
                                                      "") ...[
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              imageList[items[
                                                                  'userName']]),
                                                    )
                                                  ] else ...[
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/user_default.png'),
                                                    )
                                                  ],
                                                ],
                                                SizedBox(width: 20),
                                                Text(
                                                  items['userName'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: List.generate(
                                                  items['score'], (index) {
                                                return Icon(
                                                  Icons.star,
                                                  color: Color(0xFFFFBF0F),
                                                  size: 15.0,
                                                );
                                              }),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  items['comment'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  formattingDate(
                                                    items['create_at'],
                                                  ),
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 117, 117, 117),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                  ),
          ),
        ),
      ),
    );
  }
}
