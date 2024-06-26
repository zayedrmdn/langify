import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langify/Expert/Quizmaker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';
import 'dart:io';

class QuizMakerHome extends StatefulWidget {
  @override
  _QuizMakerHomeState createState() => _QuizMakerHomeState();
}

class _QuizMakerHomeState extends State<QuizMakerHome> {
  final _formKey = GlobalKey<FormState>();
  final quizNameController = TextEditingController();
  final quizDescriptionController = TextEditingController();
  final quizTagsController = TextEditingController();
  File? _image; 
  
  

  @override
  void dispose() {
    quizNameController.dispose();
    quizDescriptionController.dispose();
    quizTagsController.dispose();
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
    String fileName = 'quiz_images/${DateTime.now().millisecondsSinceEpoch}';
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

  void _submitQuiz() async {
    if (_formKey.currentState!.validate()) {
      final String quizName = quizNameController.text;
      final String quizDescription = quizDescriptionController.text;
      final String quizTags = quizTagsController.text;
      final String quizID = _generateRandomString(6);
      String? imageUrl = await uploadImage(); 
      DateTime now = DateTime.now();

      await FirebaseFirestore.instance.collection('Quiz').doc(quizName).set({
        'quizName': quizName,
        'quizID': quizID,
        'quizDescription': quizDescription,
        'quizTags': quizTags.split(',').map((tag) => tag.trim()).toList(),
        'Image': imageUrl,
        'quizDate': now,
      }).then((value) {
        print("Quiz Added");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizMaker(quizID: quizID,  quizName: quizName)),
        );
      }).catchError((error) {
        print("Failed to add quiz: $error");
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
        title: const Text('Quiz Maker Home'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: quizNameController,
                decoration: const InputDecoration(labelText: 'Quiz Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quiz name';
                  }
                  return null;
                },
              ),
               TextFormField( // New TextFormField for quiz description
                controller: quizDescriptionController,
                decoration: const InputDecoration(labelText: 'Quiz Description'),
                 maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quiz description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField( // Added TextFormField for quiz tags
                controller: quizTagsController,
                decoration: const InputDecoration(labelText: 'Quiz Tags (comma separated)'),
              ),
              const SizedBox(height: 20),
              if (_image != null) // Display the image if it's not null
              Container(
                height: 200, // Set a height for the image container
                width: double.infinity,
                child: Image.file(_image!, fit: BoxFit.cover),
                 ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage, // Call the getImage function when the button is pressed
                child: const Text('Upload Image'),
                 ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitQuiz,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}