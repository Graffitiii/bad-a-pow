import 'dart:convert';

import 'package:finalmo/config.dart';
import 'package:finalmo/screen/login_page/forgetConfirmOtp.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ForgetPhonenumber extends StatefulWidget {
  const ForgetPhonenumber({super.key});

  @override
  State<ForgetPhonenumber> createState() => _ForgetPhonenumberState();
}

class _ForgetPhonenumberState extends State<ForgetPhonenumber> {
  TextEditingController phoneNumberController = TextEditingController();
  bool phoneValidate = false;

  void onCheck() async {
    print("sdsad");
    if (phoneNumberController.text.isNotEmpty) {
      var regBody = {
        "phonenumber": phoneNumberController.text,
      };

      var response = await http.post(Uri.parse(checkUser),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        print('success');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ForgetConfirmOtp(
                      phonenumber: phoneNumberController.text,
                    )));
      } else {
        if (jsonResponse['error'] == 'User dont exist') {
          setState(() {
            phoneValidate = true;
          });
          print('User dont exist');
        }
      }
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
                                height: 280,
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
                                          child: Text(
                                            'กรอกเบอร์มือถือที่ลืมรหัสผ่าน',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: phoneNumberController,
                                          onChanged: (value) {
                                            setState(() {
                                              phoneValidate = false;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            labelText: 'หมายเลขโทรศัพท์*',
                                            labelStyle: TextStyle(
                                              color: Colors.black.withOpacity(
                                                  0.3100000023841858),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            fillColor: Color(0xFFEFEFEF),
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 12),
                                            border: InputBorder.none,
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.red),
                                            ),
                                            errorText: phoneValidate
                                                ? 'ไม่มีชื่อบัญชีที่ใช้หมายเลขโทรศัพท์นี้'
                                                : null,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.red),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.phone,
                                              color: Colors.grey,
                                            ),
                                            errorStyle: TextStyle(fontSize: 12),
                                          ),
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                        ),
                                        SizedBox(height: 30),
                                        ElevatedButton(
                                          onPressed: () {
                                            onCheck();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF013C58),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation:
                                                0, // Remove default button elevation
                                          ),
                                          child: Text(
                                            'ถัดไป',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
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
