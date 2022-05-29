import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'AddStoryPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerTapPage extends StatefulWidget {
  final position;
  String id;
  MarkerTapPage({required this.position, required this.id});

  @override
  State<MarkerTapPage> createState() => _MarkerTapPageState();
}

class _MarkerTapPageState extends State<MarkerTapPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.8,
          child: FutureBuilder(
            future: getStoryAndImage(widget.position),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data![0].length,
                  itemBuilder: (context, index) {
                    return createListTile(snapshot.data, index);
                  },
                );
              } else {
                return Text("Loading...");
              }
            },
          ),
        ),
        storyPlusButton(widget.position),
      ],
    );
  }

  Widget createListTile(storyAndImageList, index) {
    return Card(
        child: ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 100, minHeight: 100),
        child: Image.network(
          storyAndImageList[1][index],
          width: 100,
          height: 100,
        ),
      ),
      title: Text(storyAndImageList[0][index]),
    ));
  }

  Future<List> getStoryAndImage(position) async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('position/' + position + '/contents');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List allStory = [[], []];
    for (int i = 0; i < allData.length; i++) {
      allStory[0].add(allData[i]['story']);
      allStory[1].add(await getImageLink(allData[i]['autoID']));
    }

    print(allStory);
    return allStory;
  }

  Future getImageLink(imageName) async {
    var link = await FirebaseStorage.instance
        .ref()
        .child('/storyPicture/')
        .child(imageName.toString() + '.png')
        .getDownloadURL();

    return link;
  }

  Widget storyPlusButton(position) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        height: 100,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
        child: IconButton(
            onPressed: () {
              onStoryPlusButtonPressed();
            },
            icon: const Icon(Icons.add)),
      ),
    );
  }

  void onStoryPlusButtonPressed() {
    String temp = widget.position;
    Navigator.pop(context);
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddStoryPage(
          id: widget.id,
          position: LatLng(
              double.parse(temp.substring(
                  temp.lastIndexOf('(') + 1, temp.lastIndexOf(','))),
              double.parse(temp.substring(
                  temp.lastIndexOf(',') + 1, temp.lastIndexOf(')')))),
        );
      },
    );
  }
}
