// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

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

  @override
  void initState() {
    addCustomIcon();
    _getPolyline();
    super.initState();
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
      PointLatLng(13.744679051575686, 100.53005064632619), // Start coordinates
      PointLatLng(13.7650836, 100.5379664), // End coordinates
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

  void addCustomIcon() async {
    final Uint8List? markerIcon =
        await getBytesFromAsset('assets/images/marker.png', 100);

    setState(() {
      userMarker = BitmapDescriptor.fromBytes(markerIcon!);
    });
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
      target: LatLng(13.744679051575686, 100.53005064632619),
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
      body: GoogleMap(
        mapType: MapType.terrain,
        // myLocationEnabled: true,
        // myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(13.7650836, 100.5379664),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId("event"),
            position: LatLng(13.7650836, 100.5379664),
            infoWindow: InfoWindow(title: "สนามแบดซ่า", snippet: "สนามแบดซ่า"),
          ),
          Marker(
            markerId: const MarkerId("user"),
            position: const LatLng(13.744679051575686, 100.53005064632619),
            icon: userMarker,
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
