// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:finalmo/screen/gang/gangDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalmo/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
final List<String> level = [
  'N',
  'S',
  'P',
];
List<String> selectedlevel = [];

List<String> selectedtime = [];

class FindGang extends StatefulWidget {
  const FindGang({
    Key? key,
  }) : super(key: key);

  @override
  State<FindGang> createState() => _FindGangState();
}

class _FindGangState extends State<FindGang> {
  late String username;
  var eventlist = {};
  var jsonResponse;
  bool eventLoading = true;
  bool loading = true;
  String query = '';
  var reviewlist = {};
  Map<String, String> review = {};
  // var rating = '';

  TextEditingController eventtime = TextEditingController();
  TextEditingController eventdate = TextEditingController();
  TextEditingController distance = TextEditingController();
  TextEditingController search = TextEditingController();
  String formattedStartTime = '';
  String formattedEndTime = '';
  late Set<String> _selectedValues = {};
  List filterlist = [];
  var distancelist = {};
  final _formKey = GlobalKey<FormState>();
  String placename = '';
  double latitude = 0;
  double longitude = 0;
  String placenameSelect = '';
  double latitudeSelect = 0;
  double longitudeSelect = 0;
  String googleAPiKey = "AIzaSyC0DEere3Ykl4YG32qEmfRfG9aCpsl1igw";
  @override
  void initState() {
    initializeState();
    super.initState();
  }

  void initializeState() async {
    await initSharedPref();
    await getUserControl();
    getFilters();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var location = await Geolocator.getCurrentPosition();
    print(location);
    return location;
  }

  Future<void> getUserControl() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getUserControl', queryParameters);
    var response = await http.get(uri);

    jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      if (jsonResponse['data']['placename'] != '') {
        setState(() {
          placename = jsonResponse['data']['placename'];
          latitude = jsonResponse['data']['latitude'];
          longitude = jsonResponse['data']['longitude'];
        });
      } else {
        Position userLocation;
        userLocation = await getLocation();
        setState(() {
          latitude = userLocation.latitude;
          longitude = userLocation.longitude;
        });
        var test = await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude},${longitude}&language=th&key=${googleAPiKey}'));
        if (test.statusCode == 200) {
          var decodedData = json.decode(test.body);
          setState(() {
            placename = decodedData['results'][0]['formatted_address'];
          });

          await onSaveLocation(username, placename, latitude, longitude);
        } else {
          print('Failed with status code: ${test.statusCode}');
        }
      }
    }

    setState(() {
      loading = false;
    });
  }

  void onSearch(ssss) {
    getFilters();
  }

  Future<void> getFilters() async {
    setState(() {
      eventLoading = true;
    });
    var queryParameters = {
      'level': _selectedValues,
      'eventdate_start': "",
      'distance': distance.text,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'club': search.text
    };
    var uri = Uri.http(getUrl, '/getFilter', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);
    print(eventtime.text);
    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
      // print(jsonResponse['distance']);
      setState(() {
        filterlist = jsonResponse['data'];
        distancelist = jsonResponse['distance'];
      });
      print(distancelist);

      List<Future> reviewFutures = [];
      for (var club in filterlist) {
        reviewFutures.add(getReview(club['club']));
      }

      await Future.wait(reviewFutures);

      print(review);

      setState(() {
        eventLoading = false;
      });
      // print(formattedStartTime);
    } else {
      print(response.statusCode);
    }
  }

  Future<void> onSaveLocation(username, placename, latitude, longitude) async {
    var locationBody = {
      "userName": username,
      "placename": placename,
      "latitude": latitude,
      "longitude": longitude
    };

    print(locationBody);
    await http.put(Uri.parse(saveLocation),
        headers: {"Content-type": "application/json"},
        body: jsonEncode(locationBody));
  }

  Future<void> changeLocation() async {
    print('OLD');
    print(placename);
    print(latitude);
    print(longitude);
    print('NEW');
    print(placenameSelect);
    print(latitudeSelect);
    print(longitudeSelect);
    setState(() {
      placename = placenameSelect;
      latitude = latitudeSelect;
      longitude = longitudeSelect;
    });
  }

  String formattingDate(start, end) {
    initializeDateFormatting('th', null);

    DateTime eventStart = DateTime.parse(start);
    DateTime eventEnd = DateTime.parse(end);
    // print(eventStart);
    DateTime thaiDateStartTime = eventStart.add(Duration(hours: 7));
    DateTime thaiDateEndTime = eventEnd.add(Duration(hours: 7));

    String formattedDateTime =
        DateFormat('d MMMM H:mm', 'th').format(thaiDateStartTime);

    String formattedEndTime =
        DateFormat('H:mm น.', 'th').format(thaiDateEndTime);

    // print(formattedDateTime + "-" + formattedEndTime);
    return formattedDateTime + " - " + formattedEndTime;
  }

  Future<void> getReview(clubname) async {
    var queryParameters = {
      'clubname': clubname,
    };

    var uri = Uri.http(getUrl, '/getReviewList', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        reviewlist = jsonResponse;
        // print(averageScore(reviewlist));
        review[clubname] = averageScore(reviewlist);
      });
    }
  }

  String averageScore(reviewlist) {
    var rating = '';
    int sum = 0;
    int count = reviewlist['success'].length;

    for (var value in reviewlist['success']) {
      int score = value['score'];
      sum += score;
    }

    double average = count > 0 ? sum / count : 0;
    String formattedAverage = average.toStringAsFixed(1);
    // print('Average Score: $formattedAverage');
    rating = formattedAverage;
    return rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "หาก๊วน",
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
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(0),
            child: loading
                ? Padding(
                    padding: EdgeInsets.all(100),
                    child: DefaultTextStyle(
                      style: const TextStyle(
                          fontSize: 20.0, color: Color(0xFF00537A)),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText('Finding a place....'),
                          WavyAnimatedText('please wait a moment'),
                        ],
                        isRepeatingAnimation: true,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFFFF3333),
                              size: 30.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                'ที่อยู่ :',
                                style: TextStyle(
                                  color: Color(0xFFFF3333),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  placename,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF00537A),
                                    fontSize: 18,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                height: 40,
                                width: 40,
                                decoration: ShapeDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2, color: Color(0xFF013C58)),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
                                  child: IconButton(
                                    icon: Icon(Icons.tune, size: 23),
                                    color: Color(0xFF013C58),
                                    onPressed: () {
                                      setState(() {
                                        placenameSelect = placename;
                                        latitudeSelect = latitude;
                                        longitudeSelect = longitude;

                                        // test();
                                      });
                                      print(_selectedValues);
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.8,
                                              child: Container(
                                                child: Form(
                                                  key: _formKey,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(30),
                                                              child: Text(
                                                                  "ที่อยู่ของฉัน"),
                                                            ),
                                                            Spacer(),
                                                            TextButton(
                                                              onPressed: () {
                                                                // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่ม
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'ดูทั้งหมด',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Icon(Icons
                                                                      .arrow_forward_ios),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 0,
                                                                  horizontal:
                                                                      20),
                                                          child: Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        size:
                                                                            24,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              10),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.6,
                                                                            child:
                                                                                Text(
                                                                              placenameSelect,
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w400,
                                                                                height: 0,
                                                                              ),
                                                                              // overflow:
                                                                              //     TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      IconButton(
                                                                          icon: Icon(Icons
                                                                              .edit),
                                                                          color: Color(
                                                                              0xFF013C58),
                                                                          iconSize:
                                                                              28,
                                                                          onPressed: () =>
                                                                              {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => PlacePicker(
                                                                                      initialMapType: MapType.normal,
                                                                                      autocompleteLanguage: 'th',
                                                                                      apiKey: 'AIzaSyC0DEere3Ykl4YG32qEmfRfG9aCpsl1igw',

                                                                                      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                                                                                        return isSearchBarFocused
                                                                                            ? Container()
                                                                                            // Use FloatingCard or just create your own Widget.
                                                                                            : FloatingCard(
                                                                                                bottomPosition: 50.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                                                                                leftPosition: 10.0,
                                                                                                rightPosition: 10.0,
                                                                                                width: 500,
                                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                                                child: state == SearchingState.Searching
                                                                                                    ? Container(
                                                                                                        height: 140,
                                                                                                        color: Color.fromARGB(255, 117, 117, 117),
                                                                                                        child: Center(
                                                                                                          child: CircularProgressIndicator(
                                                                                                            color: Color.fromARGB(255, 255, 145, 0),
                                                                                                          ),
                                                                                                        ))
                                                                                                    : Container(
                                                                                                        height: 140,
                                                                                                        color: Color.fromARGB(255, 117, 117, 117),
                                                                                                        child: Padding(
                                                                                                          padding: EdgeInsets.all(10.0),
                                                                                                          child: Column(children: [
                                                                                                            Expanded(
                                                                                                              child: Text(
                                                                                                                selectedPlace?.name ?? selectedPlace?.formattedAddress ?? "Address not available",
                                                                                                                style: TextStyle(
                                                                                                                  color: Color.fromARGB(255, 255, 255, 255),
                                                                                                                  fontSize: 16,
                                                                                                                  fontWeight: FontWeight.w400,
                                                                                                                  height: 0,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            ElevatedButton(
                                                                                                              onPressed: () async {
                                                                                                                setState(() {
                                                                                                                  if (selectedPlace?.name != null) {
                                                                                                                    placenameSelect = selectedPlace!.name!;
                                                                                                                  } else {
                                                                                                                    placenameSelect = selectedPlace!.formattedAddress!;
                                                                                                                  }
                                                                                                                });
                                                                                                                setState(() {
                                                                                                                  latitudeSelect = selectedPlace!.geometry!.location.lat;
                                                                                                                  longitudeSelect = selectedPlace.geometry!.location.lng;
                                                                                                                });

                                                                                                                Navigator.of(context).pop();
                                                                                                              },
                                                                                                              style: ElevatedButton.styleFrom(
                                                                                                                primary: Color.fromARGB(255, 255, 145, 0), // สีพื้นหลังของปุ่ม
                                                                                                                shape: RoundedRectangleBorder(
                                                                                                                  borderRadius: BorderRadius.circular(10), // รูปทรงของปุ่ม
                                                                                                                ),
                                                                                                              ),
                                                                                                              child: Text(
                                                                                                                'เลือกที่นี่',
                                                                                                                style: TextStyle(
                                                                                                                  color: Color.fromARGB(255, 255, 255, 255), // สีของตัวอักษรในปุ่ม
                                                                                                                  fontSize: 16,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ]),
                                                                                                        )));
                                                                                      },
                                                                                      initialPosition: LatLng(13.744679051575686, 100.53005064632619),
                                                                                      useCurrentLocation: false,

                                                                                      resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              })
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        pageDivider(),

                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'กำหนดระยะทาง',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          20),
                                                              child: Container(
                                                                decoration:
                                                                    _buildBoxUser(),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      distance,
                                                                  decoration:
                                                                      _buildInputUser(
                                                                          'ระยะทาง (กม.)'),
                                                                  // onSaved: (String password) {
                                                                  //   profile.password = password;
                                                                  // },
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  inputFormatters: [
                                                                    FilteringTextInputFormatter
                                                                        .digitsOnly,
                                                                    LengthLimitingTextInputFormatter(
                                                                        4),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 0,
                                                                  horizontal:
                                                                      20),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                'วัน',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // ChipDateWeek(),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                                child:
                                                                    Container(
                                                                  width: 370,
                                                                  height: 50,
                                                                  child:
                                                                      DatePicker(
                                                                    eventdate:
                                                                        eventdate,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "เวลาเริ่ม",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          10),
                                                              child: Row(
                                                                children: [
                                                                  TimePick(
                                                                    eventtime:
                                                                        eventtime,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'ระดับของผู้เล่น',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            ChipLevel(
                                                                onChanged:
                                                                    (values) {
                                                                  // Update the selected values in Filter
                                                                  setState(() {
                                                                    _selectedValues =
                                                                        values;
                                                                  });
                                                                  // Print the selected values in Filter
                                                                  print(
                                                                      _selectedValues);
                                                                },
                                                                select:
                                                                    _selectedValues),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          15,
                                                                      horizontal:
                                                                          30),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        FractionallySizedBox(
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          // ระบุฟังก์ชันที่ต้องการเมื่อกดปุ่มล้างข้อมูล
                                                                          eventtime
                                                                              .clear();
                                                                          eventdate
                                                                              .clear();
                                                                          // filterlist
                                                                          //     .clear();
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Color(0xFFEFEFEF), // สีพื้นหลังของปุ่ม
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10), // รูปทรงของปุ่ม
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'ล้าง',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xFF013C58), // สีของตัวอักษรในปุ่ม
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Expanded(
                                                                    child:
                                                                        FractionallySizedBox(
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          // if location change
                                                                          Navigator.of(context)
                                                                              .pop();

                                                                          if (placenameSelect !=
                                                                              placename) {
                                                                            await onSaveLocation(
                                                                                username,
                                                                                placenameSelect,
                                                                                latitudeSelect,
                                                                                longitudeSelect);
                                                                            await changeLocation();
                                                                          }

                                                                          await getFilters();
                                                                          // print(eventtime.text);

                                                                          // print(
                                                                          //     placename);

                                                                          // Navigator.pop(context, placename);
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Color(0xFF013C58), // สีพื้นหลังของปุ่ม
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10), // รูปทรงของปุ่ม
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'ค้นหา',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white, // สีของตัวอักษรในปุ่ม
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                )),
                          ]),
                          SizedBox(
                            height: 15,
                          ),
                          Material(
                            elevation: 5.0,
                            shadowColor: Color.fromARGB(255, 0, 0, 0),
                            borderRadius: new BorderRadius.circular(30),
                            child: TextFormField(
                              controller: search,
                              onChanged: onSearch,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(Icons.search),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                fillColor: Color(0xFFF4F4F4),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                border: InputBorder.none,
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1.0, color: Colors.red),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1.0, color: Colors.red),
                                ),
                                errorStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //if there is any error, show error message
                            child: eventLoading
                                ? CircularProgressIndicator()
                                : Column(
                                    //if everything fine, show the JSON as widget
                                    children: filterlist.map<Widget>((items) {
                                      return Padding(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          GangDetail(
                                                              id: items['_id'],
                                                              club: items[
                                                                  'club'])));
                                            },
                                            child: Material(
                                              elevation: 5.0,
                                              shadowColor:
                                                  Color.fromARGB(192, 0, 0, 0),
                                              borderRadius:
                                                  new BorderRadius.circular(30),
                                              child: Container(
                                                height: 160,
                                                width: double.infinity,
                                                decoration: ShapeDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 2,
                                                        color:
                                                            Color(0xFFF5A201)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            items['club'],
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF013C58),
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              height: 0,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: Color(
                                                                    0xFFFF3333),
                                                                size: 20.0,
                                                              ),
                                                              ConstrainedBox(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5), // Adjust the value as needed
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    items[
                                                                        'placename'],
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF929292),
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              ConstrainedBox(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.15), // Adjust the value as needed
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    "(${distancelist[items['_id']].toString()} กม.)",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFFF5A201),
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      height: 0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_month,
                                                                color: Color(
                                                                    0xFF013C58),
                                                                size: 20.0,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  formattingDate(
                                                                      items[
                                                                          'eventdate_start'],
                                                                      items[
                                                                          'eventdate_end']),
                                                                  // "sdasdaw",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF929292),
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    height: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 7,
                                                          ),
                                                          if (items['level'] !=
                                                                  null &&
                                                              items['level']
                                                                  .isNotEmpty) ...[
                                                            Row(
                                                              children: [
                                                                for (int i = 0;
                                                                    i <
                                                                        items['level']
                                                                            .length;
                                                                    i++)
                                                                  Container(
                                                                    margin: i >
                                                                            0
                                                                        ? EdgeInsets.only(
                                                                            left:
                                                                                10)
                                                                        : EdgeInsets
                                                                            .zero,
                                                                    height: 22,
                                                                    width: 22,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: items['level'][i] ==
                                                                              'N'
                                                                          ? Color(
                                                                              0xFFE3D6FF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                          : items['level'][i] == 'S'
                                                                              ? Color(0x5B009020)
                                                                              : items['level'][i] == 'P'
                                                                                  ? Color(0xFFFEDEFF) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                                  : Color.fromARGB(255, 222, 234, 255),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7), // กำหนด radius ให้กรอบสี่เหลี่ยม
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        width:
                                                                            2,
                                                                        color: items['level'][i] ==
                                                                                'N'
                                                                            ? Color(0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                            : items['level'][i] == 'S'
                                                                                ? Color(0xFF00901F)
                                                                                : items['level'][i] == 'P'
                                                                                    ? Color(0xFFFC7FFF)
                                                                                    : Color(0xFFFC7FFF),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        items['level']
                                                                            [i],
                                                                        style:
                                                                            TextStyle(
                                                                          color: items['level'][i] == 'N'
                                                                              ? Color(0xFFA47AFF) // ถ้า level เป็น "N" กำหนดสีม่วง
                                                                              : items['level'][i] == 'S'
                                                                                  ? Color(0xFF00901F) // ถ้า level เป็น "S" กำหนดสีเขียว
                                                                                  : items['level'][i] == 'P'
                                                                                      ? Color(0xFFFC7FFF)
                                                                                      : Color(0xFFFC7FFF),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          height:
                                                                              0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ],
                                                          SizedBox(height: 7),
                                                          Row(children: [
                                                            Icon(
                                                              Icons.stars,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      154,
                                                                      3),
                                                              size: 20.0,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                review[items[
                                                                        'club']] ??
                                                                    '',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF929292),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        154,
                                                                        3),
                                                                size: 36.0,
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .people, // Your desired icon
                                                                color: Color(
                                                                    0xFF013C58),
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                items['join']
                                                                        .length
                                                                        .toString() +
                                                                    "/" +
                                                                    items['userlimit']
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF013C58),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height: 0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ));
                                      // Card(
                                      //   child: ListTile(
                                      //     title: Text(country['club']),
                                      //     subtitle: Text(country['contact']),
                                      //   ),
                                      // )
                                    }).toList(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}

Widget pageDivider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
    child: Container(
      width: 350,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFEBEBEB),
          ),
        ),
      ),
    ),
  );
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
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
  );
}

_launchMaps() async {
  // พิกัดที่ต้องการ (เช่นละติจูดและลองจิจูดของสถานที่ที่ต้องการ)
  final latitude = 13.7563;
  final longitude = 100.5018;

  // URL ของ Google Maps ที่มีพิกัดที่ต้องการ
  final url =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  // เปิด Google Maps ในอุปกรณ์ของผู้ใช้
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'ไม่สามารถเปิด Google Maps ได้: $url';
  }
}

class ChipLevel extends StatefulWidget {
  final void Function(Set<String> selectedValues) onChanged;
  final select;
  const ChipLevel({Key? key, this.select, required this.onChanged})
      : super(key: key);

  @override
  _ChipLevelState createState() => _ChipLevelState();
}

class _ChipLevelState extends State<ChipLevel> {
  late Set<String> _selectedValues;
  late List<bool> _isSelected;

  final List<Color> chipColors = [
    Color(0xFFF5A201),
    Color(0xFFFC7FFF),
    Color(0xFF43DC65),
  ];

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.select;
    _isSelected = List<bool>.filled(3, false);
    setState(() {
      if (widget.select.contains('N')) {
        _isSelected[0] = true;
      }
      if (widget.select.contains('S')) {
        _isSelected[1] = true;
      }
      if (widget.select.contains('P')) {
        _isSelected[2] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 3.0,
        children: List.generate(3, (index) {
          return ChoiceChip(
            pressElevation: 0.0,
            selectedColor: chipColors[index],
            backgroundColor: Colors.grey[100],
            label: Text(
              _getLevel(index),
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            selected: _isSelected[index],
            onSelected: (bool selected) {
              setState(() {
                _isSelected[index] = selected;
                if (selected) {
                  _selectedValues.add(_getLevel(index));
                } else {
                  _selectedValues.remove(_getLevel(index));
                }
              });
              // Call the onChanged callback to send the selected values to Filter
              widget.onChanged(_selectedValues);
            },
          );
        }),
      ),
    );
  }

  String _getLevel(int index) {
    switch (index) {
      case 0:
        return "N";
      case 1:
        return "S";
      case 2:
        return "P";
      default:
        return "";
    }
  }
}

class TimePick extends StatefulWidget {
  final TextEditingController eventtime;

  TimePick({
    Key? key,
    required this.eventtime,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TimePickState();
  }
}

class _TimePickState extends State<TimePick> {
  TextEditingController eventtime = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FractionallySizedBox(
        child: GestureDetector(
          onTap: () async {
            TimeOfDay? time = await getTime(
              context: context,
              title: "เลือกเวลาเริ่มกิจกรรม",
            );
            if (time != null) {
              String formattedTime = formatTime(time);
              eventtime.text = formattedTime;
              // print("formattedTime" + formattedTime);
              // print(eventtime.text);
            }
          },
          child: Container(
            decoration: _buildBoxUser(),
            child: Center(
              child: TextFormField(
                controller: eventtime,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'เลือกเวลา*',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> getTime({
    required BuildContext context,
    String? title,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "ยกเลิก",
      confirmText: confirmText ?? "บันทึก",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    return time;
  }

  String formatTime(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class DatePicker extends StatelessWidget {
  final TextEditingController eventdate;
  DatePicker({Key? key, required this.eventdate}) : super(key: key);

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
        color: Color(0xFFEFEFEF),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: TextField(
          controller: eventdate,
          decoration: InputDecoration(
            labelText: "เลือกวันที่*",
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
              String formattedDate = DateFormat.yMd().format(pickedDate);
              eventdate.text = formattedDate.toString();
            } else {
              print("Not selected");
            }
          },
        ),
      ),
    );
  }
}
