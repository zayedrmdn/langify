import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  final List<String> userFeedback = [
    "Great app! Really helpful content.",
    "I love the variety of topics covered.",
    "Could use more interactive elements.",
    "The video quality could be improved.",
    "Overall, very informative!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Content', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Container(
        color: Color(0xFF132D46),
        child: ListView.builder(
          itemCount: userFeedback.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(userFeedback[index], style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.feedback, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}


