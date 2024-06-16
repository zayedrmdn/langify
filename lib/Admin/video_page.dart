import 'package:flutter/material.dart';
import 'video_detail_page.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<String> videoList = [
    'Video 1',
    'Video 2',
    'Video 3',
    'Video 4',
    'Video 5',
    'Video 6',
    'Video 7',
    'Video 8',
    'Video 9',
    'Video 10',
  ];

  void removeVideo(int index) {
    setState(() {
      videoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Content', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Container(
        color: Color(0xFF132D46),
        child: ListView.builder(
          itemCount: videoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(videoList[index], style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoDetailPage(
                      video: videoList[index],
                      onRemove: () => removeVideo(index),
                    ),
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

