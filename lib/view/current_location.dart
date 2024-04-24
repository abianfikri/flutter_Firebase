import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(-7.8108, 110.3219), zoom: 16);

  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Current location"),
          centerTitle: true,
        ),
        body: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Position position = await _determinePosition();

              googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 16)));
              markers.clear();

              markers.add(Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: LatLng(position.latitude, position.longitude)));

              setState(() {});
            },
            label: const Text("Currentt Location"),
            icon: const Icon(Icons.location_history)));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permision denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are pemanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
