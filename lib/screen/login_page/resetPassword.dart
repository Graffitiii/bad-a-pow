import 'dart:convert';

import 'package:finalmo/config.dart';
import 'package:finalmo/screen/login_page/forgetConfirmOtp.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final phonenumber;
  ResetPassword({Key? key, required this.phonenumber}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool passwordValidate = false;

  void onSave() async {
    if (password.text.isNotEmpty && password.text.isNotEmpty) {
      if (password.text == confirmPassword.text) {
        var regBody = {
          "phonenumber": widget.phonenumber,
          "password": password.text
        };

        var response = await http.put(Uri.parse(resetPassword),
            headers: {"Content-type": "application/json"},
            body: jsonEncode(regBody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          print('success');
          showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('เปลี่ยนรหัสผ่านสำเร็จ'),
              content: const Text(
                'เปลี่ยนรหัสผ่านสำเร็จ',
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ),
          );
        } else {}
      } else {
        setState(() {
          passwordValidate = true;
        });
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
                                height: 320,
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
                                        Text(
                                          'ตั้งรหัสผ่านใหม่ของเบอร์โทรศัพท์',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          widget.phonenumber,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: password,
                                          onChanged: (value) {
                                            setState(() {
                                              passwordValidate = false;
                                            });
                                          },
                                          obscureText: true,
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
                                            labelText: 'รหัสผ่านใหม่',
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
                                        SizedBox(height: 10),
                                        TextFormField(
                                          controller: confirmPassword,
                                          onChanged: (value) {
                                            setState(() {
                                              passwordValidate = false;
                                            });
                                          },
                                          obscureText: true,
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
                                            labelText: 'ยืนยันรหัสผ่านใหม่',
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
                                            errorText: passwordValidate
                                                ? 'รหัสผ่านไม่ตรงกัน'
                                                : null,
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
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            onSave();
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
                                            'ยืนยัน',
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
                                      'ยกเลิก',
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
