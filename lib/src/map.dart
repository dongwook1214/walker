import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;

  final List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: getPosition(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(snapshot.data.latitude, snapshot.data.longitude),
                    zoom: 19,
                  ),
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                  markers: markers.toSet(),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Future<Position> getPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    print(currentPosition);
    return currentPosition;
  }
}
