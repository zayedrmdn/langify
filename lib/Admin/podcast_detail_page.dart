import 'package:flutter/material.dart';

class PodcastDetailPage extends StatelessWidget {
  final String podcast;
  final VoidCallback onRemove;

  const PodcastDetailPage({
    required this.podcast,
    required this.onRemove,
  });

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
              'assets/images/podcast.jpg', // Use a single image for all podcast items
              fit: BoxFit.cover, // Align the image to the screen
            ),
            SizedBox(height: 16),
            Text('Details for $podcast'),
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
