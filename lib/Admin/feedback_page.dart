import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Content', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Container(
        color: Color(0xFF132D46),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('FeedbackUser').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No feedback available', style: TextStyle(color: Colors.white)));
            }

            var feedbackDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: feedbackDocs.length,
              itemBuilder: (BuildContext context, int index) {
                var feedback = feedbackDocs[index].data() as Map<String, dynamic>;
                var userName = feedback.keys.first;
                var userFeedback = feedback[userName];

                return ListTile(
                  title: Text('$userName: $userFeedback', style: TextStyle(color: Colors.white)),
                  leading: Icon(Icons.feedback, color: Colors.white),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
