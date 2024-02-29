// ignore_for_file: prefer_const_constructors

import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:finalmo/screen/gang/gangOwnerDetail.dart';
import 'package:flutter/material.dart';

class MyGangOwner extends StatefulWidget {
  const MyGangOwner({super.key});

  @override
  State<MyGangOwner> createState() => _MyGangOwnerState();
}

class _MyGangOwnerState extends State<MyGangOwner> {

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => GangOwnerDetail()));
          },
          child: Material(
            elevation: 5.0,
            shadowColor: Color.fromARGB(192, 0, 0, 0),
            borderRadius: new BorderRadius.circular(30),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: ShapeDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Color(0xFFF5A201)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ignore: prefer_const_constructors
                      Text(
                        'ก๊วนแมวเหมียว',
                        style: TextStyle(
                          color: Color(0xFF013C58),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(children: [
                        Icon(
                          Icons.admin_panel_settings,
                          color: Color.fromARGB(255, 255, 154, 3),
                          size: 20.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Tamonwan zaaaaaaa',
                            style: TextStyle(
                              color: Color(0xFF929292),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 4,
                      ),
                      Row(children: [
                        Icon(
                          Icons.stars,
                          color: Color.fromARGB(255, 255, 154, 3),
                          size: 20.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            '4.3',
                            style: TextStyle(
                              color: Color(0xFF929292),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.settings,
                            color: Color.fromARGB(255, 255, 154, 3),
                            size: 36.0,
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
