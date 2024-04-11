// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:finalmo/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final eventLat;
  final eventLng;
  final eventPlacename;
  const MapPage(
      {@required this.eventLat,
      @required this.eventLng,
      Key? key,
      @required this.eventPlacename})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor userMarker = BitmapDescriptor.defaultMarker;
  late Position userLocation;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyC0DEere3Ykl4YG32qEmfRfG9aCpsl1igw";
  late String username;
  late SharedPreferences prefs;
  var myToken;
  late String userPlacename;
  late double userLat;
  late double userLng;
  bool loading = true;
  @override
  void initState() {
    initializeState();
    super.initState();
  }

  void initializeState() async {
    await initSharedPref();
    await getUserControl();
    await addCustomIcon();
    _getPolyline();

    // getFilters();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myToken = prefs.getString('token');
    });
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
    username = jwtDecodedToken['userName'];
  }

  Future<void> getUserControl() async {
    var queryParameters = {
      'userName': username,
    };
    var uri = Uri.http(getUrl, '/getUserControl', queryParameters);
    var response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        userPlacename = jsonResponse['data']['placename'];
        userLat = jsonResponse['data']['latitude'];
        userLng = jsonResponse['data']['longitude'];
      });
    }

    setState(() {
      loading = false;
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    print('asddddddddddddddddddddddddddddddddddddddddddddddddd');
    print(polyline.points);
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(userLat, userLng), // Start coordinates
      PointLatLng(widget.eventLat, widget.eventLng), // End coordinates
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    // print("object");
    // print(polylineCoordinates);
    _addPolyLine();
  }

  Future<void> addCustomIcon() async {
    final Uint8List? markerIcon =
        await getBytesFromAsset('assets/images/marker.png', 100);

    setState(() {
      userMarker = BitmapDescriptor.fromBytes(markerIcon!);
    });
  }

  void _launchMaps() async {
    // พิกัดที่ต้องการ (เช่นละติจูดและลองจิจูดของสถานที่ที่ต้องการ)
    final latitude = widget.eventLat;
    final longitude = widget.eventLng;

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

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
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

  Future goToMe() async {
    final GoogleMapController controller = await _controller.future;
    // userLocation = await getLocation();

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(userLat, userLng),
      zoom: 16,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
        actions: [
          IconButton(
              icon: Icon(Icons.person_pin_circle),
              iconSize: 28,
              onPressed: goToMe)
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _launchMaps();
        },
        style: ElevatedButton.styleFrom(
          primary: ui.Color.fromARGB(255, 255, 142, 67),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0, // Remove default button elevation
        ),
        child: Text(
          'ไปที่ Google Maps',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.eventLat, widget.eventLng),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("event"),
                  position: LatLng(widget.eventLat, widget.eventLng),
                  infoWindow: InfoWindow(title: widget.eventPlacename),
                ),
                Marker(
                  markerId: const MarkerId("user"),
                  position: LatLng(userLat, userLng),
                  icon: userMarker,
                  infoWindow: InfoWindow(title: userPlacename),
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
