import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

positionPostFunction(String id, LatLng position, String story) {
  CollectionReference positionCollection =
      FirebaseFirestore.instance.collection('position/');
  positionCollection
      .doc(position.toString())
      .set({"position": position.toString()});
  String autoID = positionCollection.doc().id.toString();
  positionCollection
      .doc(position.toString())
      .collection('contents')
      .doc(autoID)
      .set({'id': id, 'story': story});

  CollectionReference idCollection =
      FirebaseFirestore.instance.collection('id/');
  idCollection.doc(id.toString()).set({"id": id.toString()});
  idCollection
      .doc(id.toString())
      .collection("contents")
      .doc(autoID)
      .set({"autoid": autoID});
}
