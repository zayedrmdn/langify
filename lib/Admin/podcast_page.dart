import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PodcastPage extends StatefulWidget {
  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  final CollectionReference podcastsCollection = FirebaseFirestore.instance.collection('podcasts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcast', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: podcastsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var podcasts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: podcasts.length,
            itemBuilder: (context, index) {
              var podcast = podcasts[index];
              return ListTile(
                title: Text(podcast['title'], style: TextStyle(color: Color(0xFF191E29))),
                subtitle: Text('URL: ${podcast['url']}', style: TextStyle(color: Color(0xFF191E29))),
              );
            },
          );
        },
      ),
    );
  }
}
