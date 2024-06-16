import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int correctAnswers = 0;
  int wrongAnswers = 0;

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

      if (showCorrectMessage) {
        correctAnswers++;
      } else {
        wrongAnswers++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showCorrectMessage = false;
      });
    } else {
      // Optionally, show a summary or reset the quiz
      showSummary();
    }
  }

  void showSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Summary'),
          content: Text(
              'Correct Answers: $correctAnswers\nWrong Answers: $wrongAnswers'),
          actions: <Widget>[
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestionIndex = 0;
                  correctAnswers = 0;
                  wrongAnswers = 0;
                  selectedAnswerIndex = null;
                  showCorrectMessage = false;
                });
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Column(
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
              showCorrectMessage ? 'You are correct!' : 'You are incorrect!',
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
          const SizedBox(height: 20),
          Text(
            'Correct Answers: $correctAnswers',
            style: const TextStyle(fontSize: 16, color: Colors.green),
          ),
          Text(
            'Wrong Answers: $wrongAnswers',
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
