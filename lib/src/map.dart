import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'AddStoryPage.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  final String id;
  LatLng position;
  Map({required this.id, required this.position});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;
  final List<Marker> markers = [
    Marker(
      markerId: MarkerId("1"),
      draggable: true,
      onTap: () => print("Marker!"),
      position: LatLng(37.422010970140626, -122.08405483514069),
    )
  ];
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
        body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.position.latitude, widget.position.longitude),
            zoom: 19,
          ),
          onCameraMove: (CameraPosition mapPosition) {
            widget.position = mapPosition.target;
            print(widget.position);
          },
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
          markers: markers.toSet(),
        ),
        Center(
          child: Container(
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _markerButton(size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              _onMarkerButtonPressed(size);
            },
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

  void _onMarkerButtonPressed(size) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return AddStoryPage(
            id: widget.id,
            position: widget.position,
          );
        });
  }
}
