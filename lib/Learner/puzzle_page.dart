import 'package:flutter/material.dart';
import 'widgets/puzzle_buttons.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Do you want to start the quiz?',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          YesButton(),
        ],
      ),
    );
  }
}
