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
      title: 'Integrated App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SubscriptionPage(),
    );
  }
}

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchSubscriptions() async {
    List<Map<String, dynamic>> subscriptions = [];
    for (var collection in ['Admin', 'Expert', 'Learner']) {
      var querySnapshot = await _firestore.collection(collection).get();
      for (var doc in querySnapshot.docs) {
        subscriptions.add({
          'collection': collection,
          'id': doc.id,
          'name': doc['Name'],
          'status': doc['Status'],
        });
      }
    }
    return subscriptions;
  }

  void _updateSubscriptionStatus(String collection, String id, bool newStatus) async {
    await _firestore.collection(collection).doc(id).update({'Status': newStatus});
    setState(() {
      // Update UI after status change
    });
  }

  Future<void> _editNameDialog(String collection, String id, String currentName) async {
    TextEditingController nameController = TextEditingController(text: currentName);

    String? editedName = await showDialog<String>(
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

    if (editedName != null && editedName.isNotEmpty) {
      await _firestore.collection(collection).doc(id).update({'Name': editedName});
      setState(() {
        // Update UI after name edit
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: FutureBuilder(
        future: _fetchSubscriptions(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No subscriptions found.'));
          }

          var subscriptions = snapshot.data!;

          return ListView.builder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              var subscription = subscriptions[index];
              return ListTile(
                title: Text(subscription['name'], style: TextStyle(color: Color(0xFF191E29))),
                subtitle: Text('Role: ${subscription['collection']} - Status: ${subscription['status'] ? 'Subscribed' : 'Unsubscribed'}', style: TextStyle(color: Color(0xFF191E29))),
                trailing: Wrap(
                  spacing: 12,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: subscription['status'] ? Color(0xFF696E79) : Color(0xFF01C38D),
                      ),
                      child: Text(subscription['status'] ? 'Unsubscribe' : 'Subscribe'),
                      onPressed: () {
                        _updateSubscriptionStatus(subscription['collection'], subscription['id'], !subscription['status']);
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.edit, color: Color(0xFF132D46)),
                      label: Text('Edit', style: TextStyle(color: Color(0xFF132D46))),
                      onPressed: () {
                        _editNameDialog(subscription['collection'], subscription['id'], subscription['name']);
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
}
