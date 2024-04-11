import 'dart:convert';
import 'dart:async';
import 'package:finalmo/screen/login_page/forgetPhonenumber.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:finalmo/screen/login_page/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;

class ForgetConfirmOtp extends StatefulWidget {
  final phonenumber;
  ForgetConfirmOtp({Key? key, required this.phonenumber}) : super(key: key);

  @override
  State<ForgetConfirmOtp> createState() => _ForgetConfirmOtpState();
}

class _ForgetConfirmOtpState extends State<ForgetConfirmOtp> {
  // final formKey = GlobalKey<FormState>();
  // Profile profile = Profile();
  bool otpValidate = false;
  bool otpCount = false;
  var otpId = "";
  late Timer timer;
  int _start = 30;

  void initState() {
    sendOtp();
    super.initState();
  }

  void startTimer() {
    _start = 30;
    setState(() {
      otpCount = true;
    });
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            setState(() {
              otpCount = false;
            });
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void sendOtp() async {
    startTimer();

    var queryParameters = {
      'api_key': 'e5179bf7',
      'api_secret': 'eS3znKj5XFBSVRqv',
      'number': '66623413184',
      'brand': 'BadAPow',
    };

    var uri = Uri.https('api.nexmo.com', '/verify/json', queryParameters);

    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    print(response.statusCode);

    setState(() {
      otpId = jsonResponse['request_id'];
    });

    print(otpId);
  }

  void confirmOtp(code) async {
    var queryParameters = {
      'api_key': 'e5179bf7',
      'api_secret': 'eS3znKj5XFBSVRqv',
      'request_id': otpId,
      'code': code,
    };

    var uri = Uri.https('api.nexmo.com', '/verify/check/json', queryParameters);

    var response = await http.get(uri);
    print(otpId);
    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    if (jsonResponse['status'] == "0") {
      print(jsonResponse['event_id']);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ResetPassword(
                    phonenumber: widget.phonenumber,
                  )));
    } else {
      setState(() {
        otpValidate = true;
      });
    }
  }

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
                                height: 250,
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32))),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              'ใส่รหัส OTP เพื่อเปลี่ยนรหัสผ่าน',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        OtpTextField(
                                          numberOfFields: 4,
                                          enabledBorderColor: Color.fromARGB(
                                              255, 172, 172, 172),
                                          //set to true to show as box or false to show as dash
                                          showFieldAsBox: true,
                                          focusedBorderColor: Color(0xFF013C58),
                                          //runs when a code is typed in
                                          onCodeChanged: (String code) {
                                            setState(() {
                                              otpValidate = false;
                                            });
                                          },
                                          //runs when every textfield is filled
                                          onSubmit: (String verificationCode) {
                                            confirmOtp(verificationCode);
                                          },
                                          // end onSubmit
                                        ),
                                        SizedBox(height: 10),
                                        if (otpValidate) ...[
                                          Text(
                                            'รหัส OTP ไม่ถูกต้อง',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 192, 26, 26),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 10),
                                        if (otpCount) ...[
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  255, 187, 187, 187),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              "ขออีกครั้งใน $_start",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          ElevatedButton(
                                            onPressed: () {
                                              sendOtp();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF013C58),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              'ขอ OTP',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ]
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
                                                  ForgetPhonenumber()));
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
