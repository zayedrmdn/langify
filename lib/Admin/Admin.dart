import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserDetailScreen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('admins');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: adminsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var admins = snapshot.data!.docs;

          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              var admin = admins[index];
              return ListTile(
                title: Text(admin['name'], style: TextStyle(color: Color(0xFF191E29))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        name: admin['name'],
                        role: 'Admin',
                        subscribed: admin['subscribed'], // Pass subscription status
                        backgroundColor: Color(0xFF191E29), // Dark background for Admins
                      ),
                    ),
                  );
                },
                trailing: Wrap(
                  spacing: 12,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: admin['subscribed'] ? Color(0xFF696E79) : Color(0xFF01C38D),
                      ),
                      child: Text(admin['subscribed'] ? 'Unsubscribe' : 'Subscribe'),
                      onPressed: () {
                        adminsCollection.doc(admin.id).update({'subscribed': !admin['subscribed']});
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Color(0xFF132D46)),
                      label: Text('Edit', style: TextStyle(color: Color(0xFF132D46))),
                      onPressed: () async {
                        String? editedName = await _editNameDialog(context, admin['name']);
                        if (editedName != null && editedName.isNotEmpty) {
                          adminsCollection.doc(admin.id).update({'name': editedName});
                        }
                      },
                    ),
                  ],
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
