// import 'package:finalmo/model/profile.dart';
import 'dart:convert';
import 'dart:async';
import 'package:finalmo/screen/TabbarButton.dart';
import 'package:finalmo/screen/gang/findGang.dart';
import 'package:finalmo/screen/home.dart';
import 'package:finalmo/screen/login_page/signup.dart';
import 'package:flutter/material.dart';
import 'package:finalmo/screen/login_page/forgetpassword.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:getwidget/getwidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  // Profile profile = Profile();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool phoneValidate = false;
  bool passwordValidate = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void login() async {
    print("sdsad");
    if (phoneNumberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      print("hello");
      var regBody = {
        "phonenumber": phoneNumberController.text,
        "password": passwordController.text,
      };

      print(regBody);

      var response = await http.post(Uri.parse(loginUrl),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        print('Login success');
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (_) => HomePage(token: myToken)));
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => TabBarViewBottom()));
      } else {
        if (jsonResponse['error'] == 'User dont exist') {
          setState(() {
            phoneValidate = true;
          });
          print('User dont exist');
        } else if (jsonResponse['error'] == 'Password Invalid') {
          setState(() {
            passwordValidate = true;
          });
          print('Password Invalid');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00537A),
        elevation: 0,
        toolbarHeight: 0,
      ),
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
              padding: EdgeInsets.fromLTRB(40, 65, 40, 0),
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
                          child: Container(
                            width: 500,
                            height: 300,
                            decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(32))),
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'ยินดีต้อนรับ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Color(0x3F000000),
                                        //     blurRadius: 4,
                                        //     offset: Offset(0, 4),
                                        //     spreadRadius: 0,
                                        //   ),
                                        // ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: SizedBox(
                                        height: 40.0,
                                        child: TextFormField(
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
                                          // onSaved: (String email) {
                                          //   profile.email = email;
                                          // },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          // BoxShadow(
                                          //   color: Color(0x3F000000),
                                          //   blurRadius: 4,
                                          //   offset: Offset(0, 4),
                                          //   spreadRadius: 0,
                                          // ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: SizedBox(
                                        height: 40.0,
                                        child: TextFormField(
                                          controller: passwordController,
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
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.red),
                                            ),
                                            errorText: passwordValidate
                                                ? 'รหัสผผ่านไม่ถูกต้อง'
                                                : null,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.0,
                                                  color: Colors.red),
                                            ),
                                            labelText: 'รหัสผ่าน*',
                                            labelStyle: TextStyle(
                                              color: Colors.black.withOpacity(
                                                  0.3100000023841858),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            border: InputBorder.none,
                                            filled: true,
                                            fillColor: Color(0xFFEFEFEF),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 12),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          // onSaved: (String password) {
                                          //   profile.password = password;
                                          // },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
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
                                            onPressed: () {
                                              login();
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
                                              'เข้าสู่ระบบ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
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
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ForgetPasswordScreen()));
                            },
                            child: Text(
                              'ลืมรหัสผ่าน',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignUp()));
                            },
                            child: Text(
                              'สมัครสมาชิก',
                              style: GoogleFonts.inter(
                                color: Color(0xFF013C58),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
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

class BackgroundSignIn extends StatelessWidget {
  final double containerHeight;
  final Widget child;

  const BackgroundSignIn(
      {Key? key, required this.containerHeight, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            padding: EdgeInsets.fromLTRB(30, 70, 30, 0),
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
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 500,
                          height: containerHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.9),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   child: SignupObject(),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
