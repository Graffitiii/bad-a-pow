import 'dart:convert';
import 'package:finalmo/screen/gang/gangOwnerDetail.dart';
import 'package:finalmo/screen/gang/review.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCommentScreen extends StatefulWidget {
  final club;
  const AddCommentScreen({this.club, super.key});

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  TextEditingController comment = TextEditingController();

  bool light = true;
  int rating = 0;
  int average = 0;

  late String username;
  late SharedPreferences prefs;
  var myToken;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    print(widget.club);
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

  void addComment() async {
    if (rating > 0) {
      var regBody;
      if (light) {
        regBody = {
          "userName": username,
          "score": rating,
          "comment": comment.text,
          "showuser": light,
          "clubname": widget.club,
        };
      } else {
        regBody = {
          "userName": "ผู้ใช้",
          "score": rating,
          "comment": comment.text,
          "showuser": light,
          "clubname": widget.club,
        };
      }

      var response = await http.post(Uri.parse(createReview),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['success']);
    } else {
      print(rating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text(
              'ให้คะแนนก๊วน',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          backgroundColor: Color(0xFF00537A),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                addComment();
                setState(() {});
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     fullscreenDialog: true,
                //     builder: (context) => GangOwnerDetail(club: widget.club),
                //   ),
                // );
                Navigator.pop(context);
              },
            )
          ]),
      body: SafeArea(
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Container(
              child: Padding(
                padding: EdgeInsetsDirectional.all(15),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        "คะแนนก๊วน",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                          width: 25), // เพิ่มระยะห่างระหว่างข้อความกับไอคอนดาว
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                rating = index + 1; // เพิ่มคะแนนจากดาวที่ถูกกด
                                // print(rating);
                              });
                            },
                            icon: Icon(
                              Icons.star,
                              color: index < rating
                                  ? Color(
                                      0xFFFFBF0F) // สีเหลืองถ้าอยู่ในช่วงที่ถูกกด
                                  : Colors.grey, // สีเทาถ้าไม่ได้ถูกกด
                              size: 30.0,
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.10999999940395355),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        "ความคิดเห็น",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // เพิ่มระยะห่างระหว่างข้อความกับไอคอนดาว
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                    child: TextField(
                      controller: comment,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(
                            10), // กำหนดระยะห่างของข้อความภายใน TextField
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black.withOpacity(0.10999999940395355),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        "แสดงชื่อผู้รีวิว",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Switch(
                        value: light,
                        activeColor: Colors.green,
                        onChanged: (bool value) {
                          setState(() {
                            light = value;
                            // print(value);
                            // print("Value of light: $light");
                          });
                        },
                      ),
                      // เพิ่มระยะห่างระหว่างข้อความกับไอคอนดาว
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
