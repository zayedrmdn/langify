import 'package:flutter/material.dart';
import 'widgets/course_button.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CourseButton(
            title: 'Course 1',
            onPressed: () {
              // Navigate to Course 1
            },
          ),
          const SizedBox(height: 20),
          CourseButton(
            title: 'Course 2',
            onPressed: () {
              // Navigate to Course 2
            },
          ),
          const SizedBox(height: 20),
          CourseButton(
            title: 'Course 3',
            onPressed: () {
              // Navigate to Course 3
            },
          ),
          const SizedBox(height: 20),
          CourseButton(
            title: 'Course 4',
            onPressed: () {
              // Navigate to Course 4
            },
          ),
        ],
      ),
    );
  }
}
