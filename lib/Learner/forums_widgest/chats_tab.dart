import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesPage extends StatefulWidget {
  final String currentUserID;
  final String chatID;

  const MessagesPage(
      {required this.currentUserID, required this.chatID, Key? key})
      : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Accounts')
            .doc(widget.currentUserID) // Using widget.currentUserID here
            .collection('Chats')
            .doc(widget.chatID) // Using widget.chatID here
            .collection('Messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages available'));
          }

          // Render your messages based on snapshot data
          // Example: Displaying messages in a ListView
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var message = snapshot.data!.docs[index];
              // Adjust as per your message document structure
              var messageData = message.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(messageData['text'] ?? ''),
                subtitle: Text(messageData['senderID'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
