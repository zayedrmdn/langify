import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final CollectionReference musicCollection = FirebaseFirestore.instance.collection('music');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: musicCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var music = snapshot.data!.docs;

          return ListView.builder(
            itemCount: music.length,
            itemBuilder: (context, index) {
              var song = music[index];
              return ListTile(
                title: Text(song['title'], style: TextStyle(color: Color(0xFF191E29))),
                subtitle: Text('URL: ${song['url']}', style: TextStyle(color: Color(0xFF191E29))),
              );
            },
          );
        },
      ),
    );
  }
}
