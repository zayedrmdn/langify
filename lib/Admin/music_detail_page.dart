import 'package:flutter/material.dart';

class MusicDetailPage extends StatelessWidget {
  final String song;
  final VoidCallback onRemove;

  const MusicDetailPage({
    required this.song,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/music.jpg', // Use a single image for all music items
              fit: BoxFit.cover, // Align the image to the screen
            ),
            SizedBox(height: 16),
            Text('Details for $song'),
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
