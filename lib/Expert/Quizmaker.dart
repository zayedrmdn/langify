import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langify/Expert/Quiz.dart';

void main() => runApp(QuizMakerApp(quizID: 'your_quiz_id_here'));

class QuizMakerApp extends StatelessWidget {
 final String quizID;

 QuizMakerApp({required this.quizID}); 
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizMaker(quizID: quizID),
    );
  }
}

class QuizMaker extends StatefulWidget {
  final String quizID; // Add quizID field

  QuizMaker({required this.quizID}); // Constructor to accept quizID

  @override
  _QuizMakerState createState() => _QuizMakerState();
}

class _QuizMakerState extends State<QuizMaker> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> questionsAndAnswers = [];

  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();
  TextEditingController scoreController = TextEditingController(); // Step 1: Score controller

  @override
  void dispose() {
    questionController.dispose();
    answer1Controller.dispose();
    answer2Controller.dispose();
    answer3Controller.dispose();
    answer4Controller.dispose();
    scoreController.dispose();
    super.dispose();
  }

int _addQuestionPressCount = 0;

  void _addQuestion() {
  print("Attempting to add question"); // Debug: Check if method is called
  if (_formKey.currentState!.validate()) {
    print("Form is valid"); // Debug: Check if form validation passes
    questionsAndAnswers.add({
      'question': questionController.text,
      'answers': [
        answer1Controller.text,
        answer2Controller.text,
        answer3Controller.text,
        answer4Controller.text,
      ],
      'correctAnswer': 0,
      'score': int.tryParse(scoreController.text) ?? 0,
    });

    questionController.clear();
    answer1Controller.clear();
    answer2Controller.clear();
    answer3Controller.clear();
    answer4Controller.clear();
    scoreController.clear();

    _addQuestionPressCount++;

    setState(() {}); // Ensure UI is refreshed

    print("Question added. Total questions: ${questionsAndAnswers.length}");
  } else {
    print("Form is invalid"); // Debug: Form validation failed
  }
}

  void _submitQuiz() async {
  if (questionsAndAnswers.isNotEmpty) {
    final firestore = FirebaseFirestore.instance;
    String quizID = widget.quizID;
    try {
      for (var qa in questionsAndAnswers) {
        var questionWithID = {...qa, 'quizID': quizID}; // Add quizID to each question
        print("Adding question: $questionWithID"); // Debug: Print question being added
        await firestore.collection('Quiz Questions').add(questionWithID);
      }
      questionsAndAnswers.clear(); // Clear the questions list after submission
      print("All questions and answers saved successfully with quizID: $quizID");

       // Navigate to the QuizPage after successful submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuizPage()), // Replace QuizPage with your actual page class
      );
    } catch (e) {
      print("Error adding questions to Firestore: $e"); // Error handling
    }
  } else {
    print("No questions to submit"); // Debug: No questions to submit
  }
}

  // Function to generate a random 6-letter string
  String _generateRandomString(int length) {
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Maker'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                'Note: The first answer will always be marked as correct',
                style: TextStyle(color: Colors.red),
              ),
              TextFormField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Enter your question'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer1Controller,
                decoration: InputDecoration(labelText: 'Answer 1 (Correct Answer)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter answer 1';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer2Controller,
                decoration: InputDecoration(labelText: 'Answer 2'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter answer 2';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer3Controller,
                decoration: InputDecoration(labelText: 'Answer 3'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter answer 3';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: answer4Controller,
                decoration: InputDecoration(labelText: 'Answer 4'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter answer 4';
                  }
                  return null;
                },
              ),
               TextFormField(
                controller: scoreController,
                decoration: InputDecoration(labelText: 'Score for this question'), // Step 4: Score input field
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a score';
                  } else if (int.tryParse(value) == null) {
                      return 'Please enter an integer';
                  }
                  return null;
                },
              ),
              Text('Button pressed $_addQuestionPressCount times'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text('Confirm And Add Another Question'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  child: Text('Submit All Questions'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}