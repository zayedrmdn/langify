import 'package:flutter/material.dart';
import 'podcast_detail_page.dart';

class PodcastPage extends StatelessWidget {
  final List<String> podcasts = [
    'Podcast 1',
    'Podcast 2',
    'Podcast 3',
    'Podcast 4',
    'Podcast 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcast Content', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Container(
        color: Color(0xFF132D46),
        child: ListView.builder(
          itemCount: podcasts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(podcasts[index], style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PodcastDetailPage(podcast: podcasts[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

