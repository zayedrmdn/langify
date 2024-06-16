import 'package:flutter/material.dart';

class VideoDetailPage extends StatelessWidget {
  final String video;
  final VoidCallback onRemove;

  const VideoDetailPage({
    required this.video,
    required this.onRemove,
  });

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
              'assets/images/video.jpg', // Use a single image for all video items
              fit: BoxFit.cover, // Align the image to the screen
            ),
            SizedBox(height: 16),
            Text('Details for $video'),
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
