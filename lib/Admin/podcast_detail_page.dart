import 'package:flutter/material.dart';

class PodcastDetailPage extends StatelessWidget {
  final String podcast;

  const PodcastDetailPage({required this.podcast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(podcast),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/podcast.jpg', // Use a single image for all podcast items
              fit: BoxFit.cover, // Align the image to the screen
            ),
            SizedBox(height: 16),
            Text('Details for $podcast'),
          ],
        ),
      ),
    );
  }
}

