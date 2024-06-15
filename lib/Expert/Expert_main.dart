import 'package:flutter/material.dart';
import 'package:langify/Expert/Research.dart';
import 'package:langify/Expert/Quiz.dart';
import 'package:langify/Expert/Courses.dart';

class ExpertMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Main'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoursesPage()),
               );// Add your onTap code here for Course
              },
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/course.jpg', width: 230, height: 200), // Replace with your image
                  Text('Course'),
                ],
              ),
            ),
            SizedBox(height: 20), // Provides spacing between the buttons
            InkWell(
              onTap: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizPage()),
               );// Add your onTap code here for Competition
              },
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/Quiz.jpg', width: 230, height: 200), // Replace with your image
                  Text('Competition'),
                ],
              ),
            ),
            SizedBox(height: 20), // Provides spacing between the buttons
            InkWell(
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Research()),
               );
              },
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/Research.png', width: 230, height: 200), // Replace with your image
                  Text('Collaborative Research'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}