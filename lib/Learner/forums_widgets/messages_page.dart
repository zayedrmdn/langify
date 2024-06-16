import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesPage extends StatefulWidget {
  final String currentUserID;
  final String otherUserID;
  final String chatID;

  const MessagesPage({
    required this.currentUserID,
    required this.otherUserID,
    required this.chatID,
    Key? key,
  }) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      print('Fetching messages for chatID: ${widget.chatID}');
      FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatID)
          .collection('Messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            messages = snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
          });
          print('Fetched ${messages.length} messages');
        } else {
          print('No messages found for chatID: ${widget.chatID}');
        }
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void onNewMessage(String newMessageText) async {
    try {
      await FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chatID)
          .collection('Messages')
          .add({
        'senderID': widget.currentUserID,
        'text': newMessageText,
        'timestamp': Timestamp.now(),
      });
      print('Message sent');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages with ${widget.otherUserID}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text('No messages'))
                : ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message['senderID'] == widget.currentUserID
                            ? 'You'
                            : widget.otherUserID),
                        subtitle: Text(message['text'] ?? ''),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        onNewMessage(text);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement sending message functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
