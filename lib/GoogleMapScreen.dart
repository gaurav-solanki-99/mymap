import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {


   LatLng? _latLng;
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

   CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.7507104,75.8954989),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(22.66215,75.9035 ),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

   List<Marker> _marker = [];
   final List<Marker> _list = const [
     // List of Markers Added on Google Map
     Marker(markerId: MarkerId("marker_1"),
         icon: BitmapDescriptor.defaultMarker,
         position: LatLng(22.7507104,75.8954989)),
     Marker(
         markerId: MarkerId('1'),
         position: LatLng(20.42796133580664, 80.885749655962),
         infoWindow: InfoWindow(
           title: 'My Position',
         )
     ),

     Marker(
         markerId: MarkerId('2'),
         position: LatLng(25.42796133580664, 80.885749655962),
         infoWindow: InfoWindow(
           title: 'Location 1',
         )
     ),

     Marker(
         markerId: MarkerId('3'),
         position: LatLng(20.42796133580664, 73.885749655962),
         infoWindow: InfoWindow(
           title: 'Location 2',
         )
     ),
   ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          circles: circles,
          // markers: <Marker>{
          //   _setMarker()
          // },
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

   Set<Circle> circles = Set.from([Circle(
     strokeWidth: 1,
     strokeColor: Colors.blue,

     circleId: CircleId("Cicle_1"),
     center: LatLng(22.7507104,75.8954989),
     radius: 4000

   )]);

  _setMarker() {
     //return _marker;

    return Marker(markerId: MarkerId("marker_1"),
        icon: BitmapDescriptor.defaultMarker,
       position: LatLng(22.7507104,75.8954989));
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  Future<void> getCurrentLocation() async {
    Location location =  Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _latLng=LatLng(_locationData.latitude!, _locationData.longitude!);

    _kGooglePlex = CameraPosition(
      target: _latLng!,
      zoom: 14.4746,
    );
    setState(() {

    });
  }
}