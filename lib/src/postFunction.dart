import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future positionPostFunction(
    String id, LatLng position, String story, XFile image) async {
  // 위치에 따라 스토리 기록
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
      .set({'id': id, 'story': story, 'autoID': autoID});
  // 사용자의 id에 따라 autoID를 저장
  CollectionReference idCollection =
      FirebaseFirestore.instance.collection('id/');
  idCollection.doc(id.toString()).set({"id": id.toString()});
  idCollection
      .doc(id.toString())
      .collection("contents")
      .doc(autoID)
      .set({"autoid": autoID, "position": position.toString()});
  // autoID의 이름으로 사진 저장
  final storyImage = FirebaseStorage.instance
      .ref()
      .child('storyPicture/')
      .child(autoID + '.png');
  storyImage.putFile(
    File(image.path),
  );
}
