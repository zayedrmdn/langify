import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messages_page.dart';

class ChatsTab extends StatelessWidget {
  final String currentUserID;

  const ChatsTab({required this.currentUserID, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .where('participants', arrayContains: currentUserID)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading chats'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final participants = chat['participants'] as List<dynamic>;
              final otherUserID = participants
                  .firstWhere((id) => id != currentUserID)
                  .toString(); // Assuming participants are strings

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Accounts')
                    .where('username', isEqualTo: otherUserID)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  if (userSnapshot.hasError) {
                    return const ListTile(title: Text('Error loading user'));
                  }
                  if (userSnapshot.data!.docs.isEmpty) {
                    return const ListTile(title: Text('User not found'));
                  }

                  final user = userSnapshot.data!.docs[0].data()
                      as Map<String, dynamic>; // Cast to Map<String, dynamic>
                  final username =
                      user['username'] as String? ?? 'Unknown user';

                  return ListTile(
                    title: Text(username),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagesPage(
                            chatID: chat.id,
                            currentUserID: currentUserID,
                            otherUserID: otherUserID,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
