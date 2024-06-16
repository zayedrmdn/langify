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
  final TextEditingController _docUrlController = TextEditingController(); 
  DateTime submittedDate = DateTime.now();

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
      'researchDate': submittedDate,
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
        title: const Text('Design Research'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('CHOOSE TOPIC', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(hintText: 'Enter topic'),
              ),
              const SizedBox(height: 20),
              const Text('DESCRIPTION', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Enter description'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              const Text('DOCUMENT URL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _docUrlController,
                decoration: const InputDecoration(hintText: 'Enter document URL'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: getImage,
                  child: const Text('Pick Image'),
                ),
              ),
              const SizedBox(height: 20),
              _image == null ? const Text('No image selected.') : Image.file(_image!),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_image != null) {
                      uploadImage();
                    } else {
                      submitData('');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}