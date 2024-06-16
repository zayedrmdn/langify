import 'package:flutter/material.dart';

class CourseButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CourseButton({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
