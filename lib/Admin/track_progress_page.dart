import 'package:flutter/material.dart';

class TrackProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Progress', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProgressDiagram(
              title: 'Learner Progress Over Time',
              description: 'This diagram shows the progress of learners over months.',
              imagePath: 'assets/images/Digram.jpg',
            ),
            SizedBox(height: 16.0),
            ProgressDiagram(
              title: 'Course Completion Rates',
              description: 'https://blog.duolingo.com/how-well-does-duolingo-teach-speaking-skills',
              imagePath: 'assets/images/cRate.jpg', 
            ),
            SizedBox(height: 16.0),
            ProgressDiagram(
              title: 'Quiz Performance',
              description: 'https://blog.duolingo.com/how-does-duolingo-measure-learning',
              imagePath: 'assets/images/Quiz.jpg', 
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressDiagram extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  ProgressDiagram({required this.title, required this.description, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            AspectRatio(
              aspectRatio: 16/8 , 
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain, 
              ),
            ),
            SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }
}