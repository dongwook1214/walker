import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'postFunction.dart';

class AddStoryPage extends StatefulWidget {
  final String id;
  final LatLng position;
  AddStoryPage({required this.id, required this.position});
  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _storycontoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: size.height * 0.7,
          child: Column(
            children: [
              _addPhoto(size),
              _storyTextField(),
              Container(
                height: 20,
              ),
              _storyButton(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addPhoto(size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
            width: size.width * 0.85 * 0.8,
            height: size.width * 0.85 * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 1,
                )),
            child: FittedBox(
              child: _image == null
                  ? IconButton(
                      onPressed: () {
                        _pickImages();
                      },
                      icon: const Icon(Icons.add_a_photo),
                    )
                  : Image(image: FileImage(File(_image!.path))),
            )),
      ),
    );
  }

  Widget _storyTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _storycontoller,
          validator: (value) {
            if (value == null || value.isEmpty || value == '') {
              return '스토리를 입력해주세요';
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
            hintText: '스토리를 입력해 주세요.',
          ),
        ),
      ),
    );
  }

  Future _pickImages() async {
    final XFile? pickImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickImage;
    });
  }

  Widget _storyButton(size) {
    return SizedBox(
      width: size.width * 0.6,
      height: size.height * 0.07,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            positionPostFunction(
                widget.id, widget.position, _storycontoller.text, _image!);
          }
          Navigator.pop(context);
          _showSnackBar(context, '스토리가 기록됐습니다.');
          setState(() {});
        },
        child: const Text("Post!"),
        style: ElevatedButton.styleFrom(
          side: const BorderSide(width: 0.5, color: Colors.black54),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: Colors.yellow,
          onPrimary: Colors.black,
        ),
      ),
    );
  }

  void _showSnackBar(context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
