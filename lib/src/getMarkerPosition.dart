import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/src/markerTapPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('position');

Future<List> getMarkerPosition(context, id) async {
  QuerySnapshot querySnapshot = await _collectionRef.get();
  List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  List<Marker> markers = [];
  for (int i = 0; i < allData.length; i++) {
    String temp = allData[i]['position'].toString();

    markers.add(
      Marker(
        markerId: MarkerId(allData[i]['position']),
        draggable: true,
        onTap: () {
          _onMarkerButtonPressed(context, allData[i]['position'], id);
        },
        position: LatLng(
            double.parse(temp.substring(
                temp.lastIndexOf('(') + 1, temp.lastIndexOf(','))),
            double.parse(temp.substring(
                temp.lastIndexOf(',') + 1, temp.lastIndexOf(')')))),
      ),
    );
  }
  print(markers);
  return markers;
}

void _onMarkerButtonPressed(context, position, id) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MarkerTapPage(position: position, id: id);
      });
}
