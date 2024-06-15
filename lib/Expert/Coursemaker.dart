import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(CourseMakerApp(courseID: 'your_course_id_here', courseName: 'Your Course Name'));

class CourseMakerApp extends StatelessWidget {
  final String courseID;
  final String courseName;

  CourseMakerApp({required this.courseID, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CourseMaker(courseID: courseID, courseName: courseName),
    );
  }
}

class CourseMaker extends StatefulWidget {
  final String courseID;
  final String courseName;

  CourseMaker({required this.courseID, required this.courseName});

  @override
  _CourseMakerState createState() => _CourseMakerState();
}

class _CourseMakerState extends State<CourseMaker> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController unitNameController = TextEditingController();
  TextEditingController unitDescriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  bool showContentField = false;
  bool showUrlField = false;
  File? _image;
  final picker = ImagePicker();

  @override
  void dispose() {
    unitNameController.dispose();
    unitDescriptionController.dispose();
    contentController.dispose();
    urlController.dispose();
    super.dispose();
  }

  Future getImage() async {
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print('Image selected: ${_image!.path}');
      } else {
        print('No image selected.');
      }
    });
  } catch (e) {
    print('Error picking image: $e');
  }
}

  Future<String> uploadImage(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = 'images/${DateTime.now()}.png';
    Reference ref = storage.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask;
    return await ref.getDownloadURL();
  }

  void _submitUnit() async {
    if (_formKey.currentState!.validate()) {
       String imageUrl = '';
    if (_image != null) {
      imageUrl = await uploadImage(_image!); // Only upload if _image is not null
    }
      final firestore = FirebaseFirestore.instance;
      String courseID = widget.courseID;
      String courseName = widget.courseName;
      try {
        DocumentReference courseDocRef = firestore.collection('Courses').doc(courseName);
        // Retrieve the current number of units to determine the next unit number
       QuerySnapshot unitsSnapshot = await courseDocRef.collection('units').get();
       int nextUnitNumber = unitsSnapshot.docs.length + 1; // Increment to get the next unit number


        var unitData = {
          'unitName': unitNameController.text,
          'unitDescription': unitDescriptionController.text,
          'unitContent': contentController.text,
          'unitURL': urlController.text,
          'courseID': courseID,
          'imageUrl': imageUrl, // Include imageUrl in unitData
        };

        // Use the next unit number to name the document
        await courseDocRef.collection('units').doc('Unit $nextUnitNumber').set(unitData);

        unitNameController.clear();
        unitDescriptionController.clear();
        contentController.clear();
        urlController.clear();
        setState(() {
          _image = null; // Clear the image after submission
          showContentField = false;
          showUrlField = false;
        });

        print("Unit added successfully with courseID: $courseID and courseName: $courseName");
      } catch (e) {
        print("Error adding unit to Firestore: $e");
      }
    } else {
      print("Form is invalid or image not selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Unit'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: unitNameController,
                decoration: InputDecoration(labelText: 'Enter unit name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: unitDescriptionController,
                decoration: InputDecoration(labelText: 'Unit Description'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a unit description';
                  }
                  return null;
                },
              ),
              if (showContentField)
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: 3,
                ),
              if (showUrlField)
                TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(labelText: 'URL'),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showContentField = true;
                        });
                      },
                      child: Text('Content'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showUrlField = true;
                        });
                      },
                      child: Text('Links'),
                    ),
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text('Image'),
                    ),
                  ],
                ),
              ),
              if (_image != null) Image.file(_image!), // Correctly moved outside of ElevatedButton
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _submitUnit,
                  child: Text('Submit Unit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}