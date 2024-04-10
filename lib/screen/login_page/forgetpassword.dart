import 'package:finalmo/screen/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // final formKey = GlobalKey<FormState>();
  // Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("สร้างบัญชีผู้ใช้")),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF013C58), Color(0x00013C58)],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 100, 40, 0),
              child: Form(
                // key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 500,
                                height: 280,
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32))),
                                child: Container(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 40, 40, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              'ใส่รหัส OTP เพื่อแก้ไขรหัสผ่าน',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: 300,
                                          child: Wrap(
                                            spacing:
                                                10, // Adjust the spacing as needed
                                            runSpacing: 8.0,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                                child: TextFormField(),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                                child: TextFormField(),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                                child: TextFormField(),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFD9D9D9),
                                                ),
                                                child: TextFormField(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(16.0),
                                        //   child: PinCodeTextField(
                                        //     appContext: context,
                                        //     length: 4,
                                        //     onChanged: (value) {
                                        //       // Handle onChanged
                                        //     },
                                        //     onCompleted: (value) {
                                        //       // Handle onCompleted
                                        //     },
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x3F000000),
                                                    blurRadius: 5,
                                                    offset: Offset(0, 7),
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF013C58),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation:
                                                      0, // Remove default button elevation
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    'ยืนยัน',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginScreen()));
                                    },
                                    child: Text(
                                      'ย้อนกลับ',
                                      style: TextStyle(
                                        color: Color(0xFF013C58),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
