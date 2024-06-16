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
      title: 'User Role Management',
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
            onTap: () => _navigateToUserProfiles(context, 'Admin'),
            child: UserCategoryCard(
              icon: Icons.admin_panel_settings,
              title: 'Admins',
              color: Color(0xFF132D46),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Learner'),
            child: UserCategoryCard(
              icon: Icons.school,
              title: 'Learners',
              color: Color(0xFF132D46),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Expert'),
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

  void _addNewUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserPage(userType: userType)),
    );
  }

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
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserProfilePage(
                            documentId: userProfile.id,
                            initialName: userProfile['Name'],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewUser(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF01C38D),
      ),
    );
  }
}

class AddUserPage extends StatefulWidget {
  final String userType;

  AddUserPage({required this.userType});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  late TextEditingController _nameController;
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveNewUser() async {
    var collection = FirebaseFirestore.instance.collection(widget.userType);

    var newUser = {
      'Name': _nameController.text,
      'Status': _status,
    };

    await collection.add(newUser);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New ${widget.userType}', style: TextStyle(color: Color(0xFF191E29))),
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
            SwitchListTile(
              title: Text('Subscribed'),
              value: _status,
              onChanged: (bool value) {
                setState(() {
                  _status = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _saveNewUser,
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

class EditUserProfilePage extends StatefulWidget {
  final String documentId;
  final String initialName;
  final String collection;

  EditUserProfilePage({
    required this.documentId,
    required this.initialName,
    required this.collection,
  });

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late TextEditingController _nameController;
  late String _currentRole;
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _currentRole = widget.collection;

    _fetchUserStatus();
  }

  void _fetchUserStatus() async {
    var userDoc = await FirebaseFirestore.instance.collection(widget.collection).doc(widget.documentId).get();
    setState(() {
      _status = userDoc['Status'];
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_currentRole != widget.collection) {
      await _updateUserRole(_currentRole);
    }

    await FirebaseFirestore.instance
        .collection(_currentRole)
        .doc(widget.documentId)
        .update({
      'Name': _nameController.text,
      'Status': _status,
    });

    Navigator.pop(context);
  }

  Future<void> _updateUserRole(String newRole) async {
    var currentDoc = FirebaseFirestore.instance.collection(widget.collection).doc(widget.documentId);
    var newDoc = FirebaseFirestore.instance.collection(newRole).doc(widget.documentId);

    var data = (await currentDoc.get()).data();
    if (data != null) {
      await newDoc.set(data);
      await currentDoc.delete();
    }
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
            SwitchListTile(
             
              title: Text('Subscribed'),
              value: _status,
              onChanged: (bool value) {
                setState(() {
                  _status = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: Icon(Icons.save),
              label: Text('Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF01C38D),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _currentRole,
              items: <String>['Admin', 'Learner', 'Expert'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentRole = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
