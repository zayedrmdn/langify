import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile_page.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserID;

  const EditProfilePage({required this.currentUserID, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() async {
    setState(() {
      _loading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Accounts')
          .where('username', isEqualTo: widget.currentUserID)
          .get();

      final userData = snapshot.docs.first.data() as Map<String, dynamic>?;
      if (userData != null) {
        _usernameController.text = userData['username'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _bioController.text = userData['bio'] ?? '';
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void updateProfile() async {
    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newBio = _bioController.text.trim();

    if (newUsername.isEmpty || newEmail.isEmpty) {
      // Show error or handle validation
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Accounts')
          .where('username', isEqualTo: widget.currentUserID)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({
            'username': newUsername,
            'email': newEmail,
            'bio': newBio,
          });
        });
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile updated')));

      // Refresh the profile_page.dart
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfilePage(currentUserID: widget.currentUserID),
        ),
      );
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: updateProfile,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _bioController,
                    decoration: InputDecoration(labelText: 'Bio'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
