import 'package:flutter/material.dart';

class CourseButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CourseButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(title),
    );
  }
}
