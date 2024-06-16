
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langify/Expert/Quiz.dart';

void main() => runApp(QuizMakerApp(quizID: 'your_quiz_id_here', quizName: 'Your Quiz Name'));

class QuizMakerApp extends StatelessWidget {
 final String quizID;
 final String quizName; // Add quizName field

 QuizMakerApp({required this.quizID, required this.quizName}); // Modify constructor to accept quizName
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizMaker(quizID: quizID, quizName: quizName), // Pass quizName to QuizMaker
    );
  }
}

class QuizMaker extends StatefulWidget {
  final String quizID;
  final String quizName; // Add quizName field

  QuizMaker({required this.quizID, required this.quizName}); // Modify constructor to accept quizName

  @override
  _QuizMakerState createState() => _QuizMakerState();
}

class _QuizMakerState extends State<QuizMaker> {
  final _formKey = GlobalKey<FormState>();
 Map<String, Map<String, dynamic>> questionsAndAnswers = {};

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
  if (_formKey.currentState!.validate()) {
    String correctAnswer = "C1"; // Assuming the correct answer is always the first option provided

    questionsAndAnswers[questionController.text] = {
      'Options': {
        'C1': answer1Controller.text,
        'C2': answer2Controller.text,
        'C3': answer3Controller.text,
      },
      'CorrectAns': correctAnswer,
      'Score': int.tryParse(scoreController.text) ?? 0,
    };

    questionController.clear();
    answer1Controller.clear();
    answer2Controller.clear();
    answer3Controller.clear();
    scoreController.clear();

    _addQuestionPressCount++;

    setState(() {}); // Ensure UI is refreshed
  }
}

  void _submitQuiz() async {
  if (questionsAndAnswers.isNotEmpty) {
    final firestore = FirebaseFirestore.instance;
    String quizID = widget.quizID;
    String quizName = widget.quizName;
     int questionCounter = 0;

    try {
      // Get a reference to the document with quizName inside the Quiz collection
      DocumentReference quizDocRef = firestore.collection('Quiz').doc(quizName);
      
       for (var entry in questionsAndAnswers.entries) {
       questionCounter++;
       var questionWithID = {'Question': entry.key, ...entry.value, 'quizID': quizID}; // Combine question text with its details and add quizID
       print("Adding question: $questionWithID");// Debug: Print question being added
        
        // Construct document name like "Q1", "Q2", etc.
        String questionDocName = "Q$questionCounter";
        
        // Set the question data with a specific document name instead of a random ID
        await quizDocRef.collection('questions').doc(questionDocName).set(questionWithID);
      }
      
      questionsAndAnswers.clear(); // Clear the questions list after submission
      print("All questions and answers saved successfully with quizID: $quizID and quizName: $quizName");

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
              Text('$_addQuestionPressCount Questions Added'),
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