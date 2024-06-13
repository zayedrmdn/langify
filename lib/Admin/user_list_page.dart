import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: usersCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name'], style: TextStyle(color: Color(0xFF191E29))),
                trailing: TextButton.icon(
                  icon: Icon(Icons.edit, color: Color(0xFF132D46)),
                  label: Text('Edit', style: TextStyle(color: Color(0xFF132D46))),
                  onPressed: () async {
                    String? editedName = await _editNameDialog(context, user['name']);
                    if (editedName != null && editedName.isNotEmpty) {
                      usersCollection.doc(user.id).update({'name': editedName});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> _editNameDialog(BuildContext context, String currentName) async {
    TextEditingController nameController = TextEditingController(text: currentName);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(controller: nameController),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.pop(context, nameController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
