import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/material.dart';

class MyGangFollow extends StatefulWidget {
  const MyGangFollow({super.key});

  @override
  State<MyGangFollow> createState() => _MyGangFollowState();
}

class _MyGangFollowState extends State<MyGangFollow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => GangDetail()));
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
                        'ก๊วน A',
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
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
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => GangDetail()));
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
                        'ก๊วน Z',
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
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
