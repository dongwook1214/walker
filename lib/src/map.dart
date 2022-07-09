import 'package:flutter/material.dart';
import 'package:flutter_project/src/manageStoryPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'AddStoryPage.dart';
import 'package:geolocator/geolocator.dart';
import 'getMarkerPosition.dart';
import 'manageStoryPage.dart';

class Map extends StatefulWidget {
  final String id;
  LatLng position;
  Map({required this.id, required this.position});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            googleMap(),
            _markerButton(size),
          ],
        ),
      ),
    );
  }

  Widget googleMap() {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future: getMarkerPosition(context, widget.id),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      widget.position.latitude, widget.position.longitude),
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
                markers: snapshot.data.toSet(),
              );
            } else {
              return Text("Loading...");
            }
          },
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
            onLongPress: () {
              _onMarkerButtonLongPressed(size);
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

  void _onMarkerButtonLongPressed(size) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ManageStoryPage(id: widget.id);
        });
  }

  void _onMarkerButtonPressed(size) async {
    await showModalBottomSheet(
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
      },
    );
    setState(() {});
  }
}
