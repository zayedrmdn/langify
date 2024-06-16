import 'package:flutter/material.dart';
import 'forums_widgets/chats_tab.dart'; // Import ChatsTab
import 'forums_widgets/forum_tab.dart'; // Import ForumTab

class ForumsPage extends StatelessWidget {
  final String currentUserID;

  const ForumsPage({required this.currentUserID, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forums / Chats'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Forums'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatsTab(currentUserID: currentUserID), // Use ChatsTab
            const ForumTab(), // Use ForumTab
          ],
        ),
      ),
    );
  }
}
