import 'package:flutter/material.dart';

class VideoDetailPage extends StatelessWidget {
  final String video;

  const VideoDetailPage({required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/video.jpg', // Use a single image for all video items
              fit: BoxFit.cover, // Align the image to the screen
            ),
            SizedBox(height: 16),
            Text('Details for $video'),
          ],
        ),
      ),
    );
  }
}

