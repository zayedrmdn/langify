import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatelessWidget {
  void _navigateToUserProfiles(BuildContext context, String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfileListPage(userType: userType)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Admins'),
            child: UserCategoryCard(
              icon: Icons.admin_panel_settings,
              title: 'Admins',
              color: Color(0xFF132D46),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Learners'),
            child: UserCategoryCard(
              icon: Icons.school,
              title: 'Learners',
              color: Color(0xFF132D46),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Experts'),
            child: UserCategoryCard(
              icon: Icons.person,
              title: 'Experts',
              color: Color(0xFF132D46),
            ),
          ),
        ],
      ),
    );
  }
}

class UserCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  UserCategoryCard({required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.white),
        title: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}

class UserProfileListPage extends StatelessWidget {
  final String userType;

  UserProfileListPage({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Profiles', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(userType).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var userProfiles = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: userProfiles.length,
            itemBuilder: (context, index) {
              var userProfile = userProfiles[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.person, size: 40),
                  title: Text(userProfile['Name'], style: TextStyle(fontSize: 18)),
                  subtitle: Text(userProfile['Role']),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserProfilePage(
                            documentId: userProfile.id,
                            initialName: userProfile['Name'],
                            initialRole: userProfile['Role'],
                            collection: userType,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 4),
                        Text('Edit'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditUserProfilePage extends StatefulWidget {
  final String documentId;
  final String initialName;
  final String initialRole;
  final String collection;

  EditUserProfilePage({
    required this.documentId,
    required this.initialName,
    required this.initialRole,
    required this.collection,
  });

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _roleController = TextEditingController(text: widget.initialRole);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.documentId)
        .update({
      'Name': _nameController.text,
      'Role': _roleController.text,
    }).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Profile', style: TextStyle(color: Color(0xFF191E29))),
        backgroundColor: Color(0xFF01C38D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: Icon(Icons.save),
              label: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF01C38D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
