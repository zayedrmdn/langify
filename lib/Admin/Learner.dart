import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserDetailScreen.dart';

class LearnerScreen extends StatefulWidget {
  @override
  _LearnerScreenState createState() => _LearnerScreenState();
}

class _LearnerScreenState extends State<LearnerScreen> {
  final CollectionReference learnersCollection = FirebaseFirestore.instance.collection('learners');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learner', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: learnersCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var learners = snapshot.data!.docs;

          return ListView.builder(
            itemCount: learners.length,
            itemBuilder: (context, index) {
              var learner = learners[index];
              return ListTile(
                title: Text(learner['name'], style: TextStyle(color: Color(0xFF191E29))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        name: learner['name'],
                        role: 'Learner',
                        subscribed: learner['subscribed'],
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
                        backgroundColor: learner['subscribed'] ? Color(0xFF696E79) : Color(0xFF01C38D),
                      ),
                      child: Text(learner['subscribed'] ? 'Unsubscribe' : 'Subscribe'),
                      onPressed: () {
                        learnersCollection.doc(learner.id).update({'subscribed': !learner['subscribed']});
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Color(0xFF132D46)),
                      label: Text('Edit', style: TextStyle(color: Color(0xFF132D46))),
                      onPressed: () async {
                        String? editedName = await _editNameDialog(context, learner['name']);
                        if (editedName != null && editedName.isNotEmpty) {
                          learnersCollection.doc(learner.id).update({'name': editedName});
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
