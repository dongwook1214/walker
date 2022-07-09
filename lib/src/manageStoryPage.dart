import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManageStoryPage extends StatefulWidget {
  String id;
  ManageStoryPage({required this.id});

  @override
  State<ManageStoryPage> createState() => _ManageStoryPageState();
}

class _ManageStoryPageState extends State<ManageStoryPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 10,
          ),
          Text("Manage Story"),
          Container(
            height: size.height * 0.8,
            child: FutureBuilder(
              future: getUserStoryImageAndPositionAutoid(widget.id),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data[0].length,
                      itemBuilder: (context, index) {
                        return _createListTile(index, snapshot.data);
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createListTile(index, snapshot) {
    return Card(
        child: ListTile(
      onLongPress: () {
        _showMyDialog(widget.id, snapshot[3][index], snapshot[2][index]);
      },
      leading: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 100, minHeight: 100),
        child: Image.network(
          snapshot[1][index],
          width: 100,
          height: 100,
        ),
      ),
      title: Text(snapshot[0][index]),
    ));
  }

  Future<void> _showMyDialog(id, autoId, position) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정말로 삭제할까요?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('다시는 되돌릴수 없습니다!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('네'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStory(autoId, id, position);
                setState(() {});
              },
            ),
            TextButton(
              child: const Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List> getUserStoryImageAndPositionAutoid(id) async {
    List allStory = [[], [], [], []];

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('id/' + id + '/contents');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < allData.length; i++) {
      var _collectionRef2 = FirebaseFirestore.instance
          .collection('position/' + allData[i]['position'] + '/contents/');
      var storyContents = await _collectionRef2.doc(allData[i]['autoid']).get();
      await allStory[0].add(storyContents.data()!['story']);
      allStory[1].add(await getUserImageLink(allData[i]['autoid']));
      allStory[2].add(allData[i]['position']);
      allStory[3].add(allData[i]['autoid']);
    }

    print(allStory);
    return allStory;
  }

  Future getUserImageLink(imageName) async {
    var link = await FirebaseStorage.instance
        .ref()
        .child('/storyPicture/')
        .child(imageName.toString() + '.png')
        .getDownloadURL();

    return link;
  }

  Future<void> _deleteStory(autoId, id, position) async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection("id")
        .doc(id)
        .collection("contents");
    var async = _collectionRef.doc(autoId).delete();
    CollectionReference _positionCol = FirebaseFirestore.instance
        .collection("position")
        .doc(position)
        .collection("contents");
    var async2 = _positionCol.doc(autoId).delete();
    await async;
    await async2;
  }
}
