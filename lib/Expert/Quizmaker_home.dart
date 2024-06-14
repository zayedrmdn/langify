import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:langify/Expert/Quizmaker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class QuizMakerHome extends StatefulWidget {
  @override
  _QuizMakerHomeState createState() => _QuizMakerHomeState();
}

class _QuizMakerHomeState extends State<QuizMakerHome> {
  final _formKey = GlobalKey<FormState>();
  final quizNameController = TextEditingController();
  final quizDescriptionController = TextEditingController();
  XFile? _image;

  @override
  void dispose() {
    quizNameController.dispose();
    quizDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _submitQuiz() {
    if (_formKey.currentState!.validate()) {
      final String quizName = quizNameController.text;
      final String quizDescription = quizDescriptionController.text;
      final String quizID = _generateRandomString(6);

      FirebaseFirestore.instance.collection('Quiz').add({
        'quizName': quizName,
        'quizDescription': quizDescription,
        'quizID': quizID,
      }).then((value) {
        print("Quiz Added");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizMaker(quizID: quizID)),
        );
      }).catchError((error) => print("Failed to add quiz: $error"));
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
        title: Text('Quiz Maker Home'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: quizNameController,
                decoration: InputDecoration(labelText: 'Quiz Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quiz name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: quizDescriptionController,
                decoration: InputDecoration(labelText: 'Quiz Description'),
                maxLines: 5,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quiz description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
              SizedBox(height: 20),
              _image != null ? Text('Image Selected') : Text('No Image Selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitQuiz,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}