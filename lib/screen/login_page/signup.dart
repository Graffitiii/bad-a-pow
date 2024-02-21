// import 'package:finalmo/object/datepicker.dart';
import 'package:finalmo/screen/login_page/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
        containerHeight: 542,
        child: SignUpObject(),
      ),
    );
  }
}

class SignUpObject extends StatelessWidget {
  const SignUpObject({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                  height: 40.0,
                  child: TextFormField(
                    decoration: _buildInputUser('ชื่อจริง*'),
                    // onSaved: (String password) {
                    //   profile.password = password;
                    // },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: _buildBoxUser(),
                child: SizedBox(
                  height: 40.0,
                  child: TextFormField(
                    decoration: _buildInputUser('นามสกุล*'),
                    // onSaved: (String password) {
                    //   profile.password = password;
                    // },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 500,
                height: 65,
                child: DatePicker(),
              ),
              Container(
                decoration: _buildBoxUser(),
                child: SizedBox(
                  height: 40.0,
                  child: TextField(
                    decoration: _buildInputUser('เบอร์โทรศัพท์*'),
                    keyboardType:
                        TextInputType.phone, // Set the keyboard type to phone
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Allow only digits
                    // onSaved: (String password) {
                    //   profile.password = password;
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
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: 'OTP',
                      labelStyle: TextStyle(
                        color: Colors.black.withOpacity(0.3100000023841858),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Color(0xFFEFEFEF),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    ),
                    keyboardType:
                        TextInputType.phone, // Set the keyboard type to phone
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ], // Allow only digits
                    // onSaved: (String password) {
                    //   profile.password = password;
                    // },
                  ),
                ),
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
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0, // Remove default button elevation
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

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

                setState(() {
                  dateController.text = formattedDate.toString();
                });
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

  const PasswordField({
    Key? key,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

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

InputDecoration _buildInputUser(String labelText) {
  return InputDecoration(
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
