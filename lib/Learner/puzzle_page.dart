import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        body: const Center(
          child: FirestoreDataDisplay(),
        ),
      ),
    );
  }
}

class FirestoreDataDisplay extends StatefulWidget {
  const FirestoreDataDisplay({super.key});

  @override
  _FirestoreDataDisplayState createState() => _FirestoreDataDisplayState();
}

class _FirestoreDataDisplayState extends State<FirestoreDataDisplay> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool showCorrectMessage = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Quiz')
        .doc('MathQuiz')
        .collection('questions')
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          questions = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          currentQuestionIndex = 0;
          selectedAnswerIndex = null;
          showCorrectMessage = false;
        });
      } else {
        print('No questions available');
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
    }
  }

  void handleAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      showCorrectMessage = questions[currentQuestionIndex]['CorrectAns'] ==
          questions[currentQuestionIndex]['Options'].keys.elementAt(index);
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      selectedAnswerIndex = null;
      showCorrectMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Question: ${currentQuestion['Question']}',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        Column(
          children: List.generate(
            currentQuestion['Options'].length,
            (index) => RadioListTile<int>(
              title: Text(currentQuestion['Options'].values.elementAt(index)),
              value: index,
              groupValue: selectedAnswerIndex,
              onChanged: selectedAnswerIndex == null
                  ? (value) => handleAnswer(value!)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (selectedAnswerIndex != null)
          Text(
            showCorrectMessage ? 'You are correct!' : 'Try again!',
            style: TextStyle(
              fontSize: 18,
              color: showCorrectMessage ? Colors.green : Colors.red,
            ),
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: nextQuestion,
          child: Text(currentQuestionIndex < questions.length - 1
              ? 'Next Question'
              : 'Finish'),
        ),
      ],
    );
  }
}
