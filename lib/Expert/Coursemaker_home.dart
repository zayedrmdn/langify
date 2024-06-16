import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langify/Expert/Coursemaker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';
import 'dart:io';

class CoursemakerHome extends StatefulWidget {
  @override
  _CoursemakerHomeState createState() => _CoursemakerHomeState();
}

class _CoursemakerHomeState extends State<CoursemakerHome> {
  final _formKey = GlobalKey<FormState>();
  final courseNameController = TextEditingController();
  final courseDescriptionController = TextEditingController();
  final courseTagsController = TextEditingController();
  File? _image;
  DateTime now = DateTime.now();

  @override
  void dispose() {
    courseNameController.dispose();
    courseDescriptionController.dispose();
    courseTagsController.dispose();
    super.dispose();
  }

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

  Future<String?> uploadImage() async {
    if (_image == null) return null;
    String fileName = 'course_images/${DateTime.now().millisecondsSinceEpoch}';
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    try {
      await ref.putFile(_image!);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error during file upload: $e');
      return null;
    }
  }

  void _submitCourse() async {
    if (_formKey.currentState!.validate()) {
      final String courseName = courseNameController.text;
      final String courseDescription = courseDescriptionController.text;
      final String courseTags = courseTagsController.text;
      final String courseID = _generateRandomString(6);
      String? imageUrl = await uploadImage(); // Upload the image and get the URL

      await FirebaseFirestore.instance.collection('Courses').doc(courseName).set({
        'courseName': courseName,
        'courseID': courseID,
        'courseDescription': courseDescription,
        'courseTags': courseTags.split(',').map((tag) => tag.trim()).toList(),
        'Image': imageUrl,
        'courseDate': now,
      }).then((value) {
        print("Course Added");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseMakerApp(courseID: courseID, courseName: courseName)),
        );
      }).catchError((error) {
        print("Failed to add course: $error");
        return Future<Null>.value(null);
      });
    }
  }

  String _generateRandomString(int length) {
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Maker Home'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: courseNameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: courseDescriptionController,
                decoration: const InputDecoration(labelText: 'Course Description'),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: courseTagsController,
                decoration: const InputDecoration(labelText: 'Course Tags (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one tag';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_image != null)
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage,
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCourse,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}