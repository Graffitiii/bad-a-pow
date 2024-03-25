import 'package:finalmo/reviewModel.dart';
import 'package:finalmo/screen/gang/addcomment.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
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

  var username = '';
  // late String username;
  late SharedPreferences prefs;
  var myToken;

  var reviewlist = {};

  @override
  void initState() {
    getReview(widget.club);
    super.initState();
    initSharedPref();
    print(widget.club);
    print(widget.owner);
  }

  void initSharedPref() async {
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
    print("sesss:" + clubname);

    setState(() {
      loading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: widget.owner != username
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
                                color: const Color.fromARGB(255, 255, 255, 255),
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
                      : Column(
                          children: reviewlist['success'].map<Widget>((items) {
                          return Padding(
                              padding: EdgeInsetsDirectional.all(5),
                              child: Container(
                                  decoration:
                                      BoxDecoration(color: Color(0xFFD9D9D9)),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 15, 5, 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/profile1.jpg'),
                                              ),
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
                                        ],
                                      ))));
                        }).toList()),
                ),
        ),
      ),
    );
  }
}
