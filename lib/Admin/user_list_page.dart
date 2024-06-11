import 'package:flutter/material.dart';

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
        title: Text('User List'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Admins'),
            child: UserCategoryCard(
              icon: Icons.admin_panel_settings,
              title: 'Admins',
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Learners'),
            child: UserCategoryCard(
              icon: Icons.school,
              title: 'Learners',
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () => _navigateToUserProfiles(context, 'Tutors'),
            child: UserCategoryCard(
              icon: Icons.person,
              title: 'Tutors',
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

  UserCategoryCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

class UserProfileListPage extends StatelessWidget {
  final String userType;

  UserProfileListPage({required this.userType});

  @override
  Widget build(BuildContext context) {
    // Mock data for user profiles
    final List<Map<String, String>> userProfiles = [
      {'name': 'John Doe', 'role': userType},
      {'name': 'Jane Smith', 'role': userType},
      {'name': 'Emily Johnson', 'role': userType},
      // Add more mock profiles as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Profiles'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: userProfiles.length,
        itemBuilder: (context, index) {
          final userProfile = userProfiles[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.person, size: 40),
              title: Text(userProfile['name']!, style: TextStyle(fontSize: 18)),
              subtitle: Text(userProfile['role']!),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserProfilePage(
                        initialName: userProfile['name']!,
                        initialRole: userProfile['role']!,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditUserProfilePage extends StatefulWidget {
  final String initialName;
  final String initialRole;

  EditUserProfilePage({required this.initialName, required this.initialRole});

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
    // Logic to save the profile can be added here
    // For now, we simply navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
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
          ],
        ),
      ),
    );
  }
}
