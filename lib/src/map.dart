import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'markerButtonFunction.dart';

class Map extends StatefulWidget {
  const Map({Key? key, id}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;

  final List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          googleMap(),
          _markerButton(size),
        ],
      ),
    );
  }

  Widget googleMap() {
    return Scaffold(
      body: FutureBuilder(
        future: getPosition(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
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
        },
      ),
    );
  }

  Widget _markerButton(size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Icon(
              Icons.add_location_alt_outlined,
              size: 30,
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(size.width * 0.15, size.width * 0.15),
              shape: const CircleBorder(),
              elevation: 10,
            ),
          ),
          Container(height: 10),
        ],
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
