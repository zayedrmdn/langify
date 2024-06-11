import 'package:flutter/material.dart';

class TrackProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Progress'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProgressDiagram(
              title: 'Learner Progress Over Time',
              description: 'This diagram shows the progress of learners over a period of time.',
            ),
            SizedBox(height: 16.0),
            ProgressDiagram(
              title: 'Course Completion Rates',
              description: 'This diagram displays the completion rates of various courses.',
            ),
            SizedBox(height: 16.0),
            ProgressDiagram(
              title: 'Quiz Performance',
              description: 'This diagram illustrates the performance of learners in quizzes.',
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

  ProgressDiagram({required this.title, required this.description});

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
            Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Diagram Placeholder',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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
