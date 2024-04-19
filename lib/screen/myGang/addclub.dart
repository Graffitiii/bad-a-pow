import 'dart:convert';

import 'package:finalmo/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddClub extends StatefulWidget {
  final username;
  const AddClub({@required this.username, Key? key}) : super(key: key);

  @override
  State<AddClub> createState() => _AddClubState();
}

class _AddClubState extends State<AddClub> {
  TextEditingController clubname = TextEditingController();
  void addClubtoData() async {
    if (clubname.text.isNotEmpty) {
      var regBody = {
        "owner": widget.username,
        "follower": [],
        "clubname": clubname.text,
        "admin": [],
        "event_id": []
      };

      var response = await http.post(Uri.parse(createClub),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);
      if (jsonResponse['status']) {
        clubname.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('สร้างกลุ่ม'),
      content: TextField(
        controller: clubname,
        decoration: InputDecoration(hintText: "ใส่ชื่อกลุ่มที่ต้องการ"),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            Navigator.of(context).pop();
            addClubtoData();
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('สร้างสำเร็จ'),
                content: const Text(
                  'กลุ่มได้ถูกสร้างแล้ว',
                  style: TextStyle(fontSize: 18),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                    child: const Text('ตกลง'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
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
    color: Color(0xFFEFEFEF),
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
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
  );
}

Widget buildTextFieldWithTitle(
    String title, String hintText, TextEditingController clubname) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          decoration: _buildBoxUser(),
          child: SizedBox(
            height: 40.0,
            child: TextFormField(
              controller: clubname,
              decoration: _buildInputUser(hintText),
              // onSaved: (String password) {
              //   profile.password = password;
              // },
              keyboardType: TextInputType.text,
            ),
          ),
        ),
      ),
    ],
  );
}
