// import 'package:finalmo/object/datepicker.dart';
import 'dart:convert';
import 'dart:async';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundSignIn(
        containerHeight: 500,
        child: SignUpObject(),
      ),
    );
  }
}

class SignUpObject extends StatefulWidget {
  const SignUpObject({super.key});

  @override
  State<SignUpObject> createState() => _SignUpObjectState();
}

class _SignUpObjectState extends State<SignUpObject> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool usernameValidate = false;

  void addUserControl() async {
    var regBody = {
      "userName": userNameController.text,
      "ownerPermission": false,
      "adminOf": [],
      "ownerOf": [],
      "follow": [],
      "pending": [],
      "join": [],
      "placename": "",
      "latitude": 0,
      "longitude": 0
    };

    var response = await http.post(Uri.parse(userControl),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    print('userControl Status:');
    print(jsonResponse['status']);
    if (jsonResponse['status']) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  void registerUser() async {
    if (userNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        otpController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      var regBody = {
        "phonenumber": phoneNumberController.text,
        "password": passwordController.text,
        "birthDate": dateController.text,
        "userName": userNameController.text,
        "picture": "",
        "gender": "",
        "level": "",
        "about": "",
        "ageShow": false
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        addUserControl();
      } else {
        setState(() {
          usernameValidate = true;
        });
        print('asdfwgrwgwgw');
        print(usernameValidate);
      }
    }
  }

  var otpId = "";
  bool otpCount = false;
  bool regisButton = false;
  bool phoneCheck = false;

  late Timer timer;
  int _start = 30;
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

  void confirmOtp() async {
    var queryParameters = {
      'api_key': 'e5179bf7',
      'api_secret': 'eS3znKj5XFBSVRqv',
      'request_id': otpId,
      'code': otpController.text,
    };

    var uri = Uri.https('api.nexmo.com', '/verify/check/json', queryParameters);

    var response = await http.get(uri);
    print(otpId);
    print(response.statusCode);

    if (response.statusCode == 200) {
      setState(() {
        regisButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      decoration: _buildBoxUser(),
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: userNameController,
                          decoration: _buildInputUser(
                              'ชื่อผู้ใช้*', usernameValidate ? "Error" : null),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
                          // onSaved: (String password) {
                          //   profile.password = password;
                          // },
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 40,
                    child: Container(
                      width: 500,
                      height: 65,
                      child: DatePicker(
                        dateController: dateController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: _buildBoxUser(),
                          child: SizedBox(
                            height: 40.0,
                            child: TextField(
                              onChanged: (value) => {
                                if (value.length < 10 || value.isEmpty)
                                  {setState(() => phoneCheck = false)}
                                else
                                  {setState(() => phoneCheck = true)}
                              },
                              controller: phoneNumberController,
                              decoration: _buildInputUser('เบอร์โทรศัพท์*',
                                  usernameValidate ? "Error" : null),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 5), // เพิ่มระยะห่างระหว่าง TextField และปุ่ม
                      if (otpCount) ...[
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 187, 187, 187),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                          onPressed: phoneCheck
                              ? () {
                                  sendOtp();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF013C58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: _buildBoxUser(),
                          child: SizedBox(
                            height: 40.0,
                            child: TextField(
                              controller: otpController,
                              decoration: _buildInputUser(
                                  'OTP*', usernameValidate ? "Error" : null),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 10), // เพิ่มระยะห่างระหว่าง TextField และปุ่ม
                      if (regisButton) ...[
                        ElevatedButton(
                          onPressed: () {
                            confirmOtp();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF02D417),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'ยืนยันสำเร็จ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () {
                            confirmOtp();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF013C58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'ยืนยัน',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: PasswordField(
                      labelText: 'รหัสผ่าน*',
                      onChanged: (value) {
                        // Handle password change
                      },
                      passwordController: passwordController,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: PasswordField(
                      labelText: 'ยืนยันรหัสผ่าน*',
                      onChanged: (value) {
                        // Handle password confirmation change
                      },
                      passwordController: confirmPasswordController,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: regisButton
                              ? () {
                                  registerUser();
                                }
                              : null,
                          // onPressed: () {
                          //   registerUser();
                          // },

                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF013C58),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0, // Remove default button elevation
                          ),
                          child: Text(
                            'สมัครสมาชิก',
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
            )),
      ),
    );
  }
}

// class DatePicker extends StatefulWidget {

//   @override
//   State<DatePicker> createState() => _DatePickerState();
// }

class DatePicker extends StatelessWidget {
  // TextEditingController dateController = TextEditingController();
  final TextEditingController dateController;

  DatePicker({Key? key, required this.dateController}) : super(key: key);
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Date picker")),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
          height: 40.0,
          child: TextField(
            controller: dateController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.calendar_today,
                color: Colors.grey,
              ),
              labelText: "Enter Date",
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.3100000023841858),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(5.0),
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xFFEFEFEF),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat("yyyy-MM-dd").format(pickedDate);

                dateController.text = formattedDate.toString();
              } else {
                print("Not selected");
              }
            },
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final String labelText;
  final ValueChanged<String> onChanged;
  final TextEditingController passwordController;
  PasswordField(
      {Key? key,
      required this.labelText,
      required this.onChanged,
      required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SizedBox(
        height: 40.0,
        child: TextFormField(
          controller: passwordController,
          obscureText: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.black.withOpacity(0.3100000023841858),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: Color(0xFFEFEFEF),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          ),
        ),
      ),
    );
  }
}

BoxDecoration _buildBoxUser() {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Color(0x3F000000),
        blurRadius: 4,
        offset: Offset(0, 4),
        spreadRadius: 0,
      ),
    ],
    borderRadius: BorderRadius.circular(5.0),
  );
}

InputDecoration _buildInputUser(String labelText, String? errorText) {
  return InputDecoration(
    errorText: errorText,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(5.0),
    ),
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.black.withOpacity(0.3100000023841858),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    border: InputBorder.none,
    filled: true,
    fillColor: Color(0xFFEFEFEF),
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
  );
}
