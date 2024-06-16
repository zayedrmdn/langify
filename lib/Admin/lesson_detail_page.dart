import 'package:flutter/material.dart';

class LessonDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onRemove;

  const LessonDetailPage({
    required this.title,
    required this.description,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(description),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onRemove();
                Navigator.pop(context);
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

