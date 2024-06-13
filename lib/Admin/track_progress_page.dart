import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackProgressPage extends StatefulWidget {
  @override
  _TrackProgressPageState createState() => _TrackProgressPageState();
}

class _TrackProgressPageState extends State<TrackProgressPage> {
  final CollectionReference progressCollection = FirebaseFirestore.instance.collection('progress');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Progress', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: progressCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var progressData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: progressData.length,
            itemBuilder: (context, index) {
              var progress = progressData[index];
              return ListTile(
                title: Text(progress['user'], style: TextStyle(color: Color(0xFF191E29))),
                subtitle: Text('Progress: ${progress['percentage']}%', style: TextStyle(color: Color(0xFF191E29))),
              );
            },
          );
        },
      ),
    );
  }
}
