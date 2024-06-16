import 'package:flutter/material.dart';
import 'package:langify/Expert/Research.dart';
import 'package:langify/Expert/Quiz.dart';
import 'package:langify/Expert/Courses.dart';
import 'package:langify/utils/color_utils.dart';

class ExpertMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Main'),
        backgroundColor: hexStringToColor("696E79"),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ExpertButton(
              imagePath: 'assets/images/course.jpg',
              label: 'Course',
              page: CoursesPage(),
            ),
            SizedBox(height: 20),
            ExpertButton(
              imagePath: 'assets/images/Quiz.jpg',
              label: 'Competition',
              page: QuizPage(),
            ),
            SizedBox(height: 20),
            ExpertButton(
              imagePath: 'assets/images/Research.png',
              label: 'Collaborative Research',
              page: Research(),
            ),
          ],
        ),
      ),
       backgroundColor: hexStringToColor("696E79"),
    );
  }
}

class ExpertButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final Widget page;

  const ExpertButton({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Ensure no extra padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Maintain the specified shape
            ),
            minimumSize: Size(230, 200), // Specify the button's size
          ),
          child: Container(
            width: 230,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover, // Cover the button area without stretching
              ),
            ),
          ),
        ),
        SizedBox(height: 8), // Add space between the image and the text
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // Make the text bold,
          ),
      ],
    );
  }
}