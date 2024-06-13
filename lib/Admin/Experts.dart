import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserDetailScreen.dart';

class ExpertsScreen extends StatefulWidget {
  @override
  _ExpertsScreenState createState() => _ExpertsScreenState();
}

class _ExpertsScreenState extends State<ExpertsScreen> {
  final CollectionReference expertsCollection = FirebaseFirestore.instance.collection('experts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Experts', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: expertsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var experts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: experts.length,
            itemBuilder: (context, index) {
              var expert = experts[index];
              return ListTile(
                title: Text(expert['name'], style: TextStyle(color: Color(0xFF191E29))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        name: expert['name'],
                        role: 'Expert',
                        subscribed: expert['subscribed'],
                        backgroundColor: Color(0xFF191E29),
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
                        backgroundColor: expert['subscribed'] ? Color(0xFF696E79) : Color(0xFF01C38D),
                      ),
                      child: Text(expert['subscribed'] ? 'Unsubscribe' : 'Subscribe'),
                      onPressed: () {
                        expertsCollection.doc(expert.id).update({'subscribed': !expert['subscribed']});
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Color(0xFF132D46)),
                      label: Text('Edit', style: TextStyle(color: Color(0xFF132D46))),
                      onPressed: () async {
                        String? editedName = await _editNameDialog(context, expert['name']);
                        if (editedName != null && editedName.isNotEmpty) {
                          expertsCollection.doc(expert.id).update({'name': editedName});
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
