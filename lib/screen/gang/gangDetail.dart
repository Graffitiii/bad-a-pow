import 'package:flutter/material.dart';

class GangDetail extends StatefulWidget {
  const GangDetail({super.key});

  @override
  State<GangDetail> createState() => _GangDetailState();
}

class _GangDetailState extends State<GangDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'รายละเอียด',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00537A),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
        ),
      ),
    );
  }
}
