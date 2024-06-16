import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'forum_details_page.dart';
import 'forum_card.dart'; // Import your ForumCard widget

class ForumTab extends StatelessWidget {
  const ForumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Forums').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading forums'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No forums available'));
        }

        final forums = snapshot.data!.docs;
        return ListView.builder(
          itemCount: forums.length,
          itemBuilder: (context, index) {
            final forum = forums[index];
            final forumData = forum.data() as Map<String, dynamic>;
            final title = forumData['title'] ?? 'No Title';
            final creatorID = forumData['creatorID'] ?? 'Unknown';

            return ForumCard(
              title: title,
              creatorID: creatorID,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForumDetailsPage(
                      forumID: forum.id,
                      currentUserId: creatorID,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
