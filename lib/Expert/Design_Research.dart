import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class DesignResearch extends StatefulWidget {
  @override
  _DesignResearchState createState() => _DesignResearchState();
}

class _DesignResearchState extends State<DesignResearch> {
  File? _image;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _docUrlController = TextEditingController(); // Controller for document URL

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) return;
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    try {
      await ref.putFile(_image!);
      print('File uploaded successfully');
      String downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl');
      submitData(downloadUrl);
    } catch (e) {
      print('Error during file upload or URL retrieval: $e');
    }
  }

  Future submitData(String imageUrl) async {
    await FirebaseFirestore.instance.collection('Research').add({
      'Topic': _topicController.text,
      'Description': _descriptionController.text,
      'Image': imageUrl,
      'DocumentURL': _docUrlController.text, 
      }).then((value) {
    // Navigate back to the previous screen after successful submission
    Navigator.pop(context);
  }).catchError((error) {
    // Handle any errors here
    print("Failed to add document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Design Research'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('CHOOSE TOPIC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(hintText: 'Enter topic'),
              ),
              SizedBox(height: 20),
              Text('DESCRIPTION', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Enter description'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              Text('DOCUMENT URL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _docUrlController,
                decoration: InputDecoration(hintText: 'Enter document URL'),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: getImage,
                  child: Text('Pick Image'),
                ),
              ),
              SizedBox(height: 20),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_image != null) {
                      uploadImage();
                    } else {
                      submitData('');
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}