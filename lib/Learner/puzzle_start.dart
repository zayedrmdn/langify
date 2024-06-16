import 'package:flutter/material.dart';
import 'puzzle_page.dart'; // Import your puzzle page

class PuzzleStart extends StatefulWidget {
  const PuzzleStart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PuzzleStartState createState() => _PuzzleStartState();
}

class _PuzzleStartState extends State<PuzzleStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Start'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Do you want to start the Quiz?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              child: const Text('Start Puzzle'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FirestoreDataDisplay()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
