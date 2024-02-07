// import 'package:finalmo/model/profile.dart';
import 'package:finalmo/screen/signup.dart';
import 'package:flutter/material.dart';
import 'package:finalmo/screen/forgetpassword.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:getwidget/getwidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              padding: EdgeInsets.fromLTRB(40, 180, 40, 0),
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
                            height: 320,
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
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0),
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
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          fillColor: Color(0xFFEFEFEF),
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12),
                                          border: InputBorder.none,
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.0, color: Colors.red),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.0, color: Colors.red),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: Colors.grey,
                                          ),
                                          errorStyle: TextStyle(fontSize: 12),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // onSaved: (String email) {
                                        //   profile.email = email;
                                        // },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x3F000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: TextFormField(
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          labelText: 'รหัสผ่าน*',
                                          labelStyle: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.3100000023841858),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Color(0xFFEFEFEF),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12),
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
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF013C58),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation:
                                                  0, // Remove default button elevation
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
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
