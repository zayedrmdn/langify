import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_widgets/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final String currentUserID;

  const ProfilePage({required this.currentUserID, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfilePage(currentUserID: currentUserID),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('Accounts')
              .where('username', isEqualTo: currentUserID)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading profile'));
            }

            final userData =
                snapshot.data?.docs.first.data() as Map<String, dynamic>?;

            if (userData == null) {
              return Center(child: Text('User not found'));
            }

            final username = userData['username'] ?? 'No username';
            final email = userData['email'] ?? 'No email';
            final bio = userData['bio'] ?? 'No bio';

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: <Widget>[
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.account_circle, size: 100),
                ),
                SizedBox(height: 20),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      username,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(email),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(bio),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
