import 'package:flutter/material.dart';

class AddCommentScreen extends StatefulWidget {
  const AddCommentScreen({super.key});

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
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
              onPressed: () {},
            )
          ]),
      body: Comment(),
    );
  }
}

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool light = true;
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          });
                        },
                      )
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
