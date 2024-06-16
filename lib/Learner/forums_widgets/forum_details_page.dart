import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumDetailsPage extends StatefulWidget {
  final String currentUserId;
  final String forumID;

  const ForumDetailsPage({
    required this.forumID,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  _ForumDetailsPageState createState() => _ForumDetailsPageState();
}

class _ForumDetailsPageState extends State<ForumDetailsPage> {
  final TextEditingController _replyController = TextEditingController();

  void _postReply() async {
    String replyText = _replyController.text.trim();
    if (replyText.isEmpty) {
      return; // Do not post empty replies
    }

    try {
      // Add the reply to Firestore
      await FirebaseFirestore.instance
          .collection('Forums')
          .doc(widget.forumID)
          .collection('Replies')
          .add({
        'userID': widget.currentUserId,
        'text': replyText,
        'timestamp': Timestamp.now(),
      });

      // Clear the reply text field after posting
      _replyController.clear();
    } catch (e) {
      // Handle error posting reply
      print('Error posting reply: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Forums')
                  .doc(widget.forumID)
                  .collection('Replies')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading replies'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No replies yet'));
                }

                final replies = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    final reply = replies[index];
                    final replyData = reply.data() as Map<String, dynamic>;
                    final userID = replyData['userID'] ?? 'Unknown';
                    final text = replyData['text'] ?? 'No text';
                    final timestamp = replyData['timestamp']?.toDate();

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'by $userID',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                timestamp != null
                                    ? '${timestamp.day}/${timestamp.month}/${timestamp.year}'
                                    : '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Enter your reply',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _postReply,
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}
