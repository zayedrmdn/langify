import 'package:flutter/material.dart';
import 'lesson_detail_page.dart';

class LessonPage extends StatelessWidget {
  final List<Map<String, String>> lessons = [
    {'title': 'Lesson 1', 'description': 'Description for Lesson 1'},
    {'title': 'Lesson 2', 'description': 'Description for Lesson 2'},
    // Add more lessons here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Container(
        color: Color(0xFF132D46),
        child: ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            return LessonItem(
              title: lessons[index]['title']!,
              description: lessons[index]['description']!,
            );
          },
        ),
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  final String title;
  final String description;

  const LessonItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Color(0xFF191E29),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(description, style: TextStyle(color: Colors.white)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonDetailPage(
                title: title,
                description: description,
              ),
            ),
          );
        },
      ),
    );
  }
}
