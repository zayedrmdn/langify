import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserDetailScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final CollectionReference accountsCollection =
      FirebaseFirestore.instance.collection('Accounts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF132D46),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: accountsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final admins = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: admins.length,
            itemBuilder: (context, index) {
              var admin = admins[index];
              return ListTile(
                title: Text(admin['Name'] ?? 'Unknown',
                    style: const TextStyle(color: Color(0xFF191E29))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        name: admin['Name'] ?? 'Unknown',
                        role: 'Admin',
                        subscribed: admin['Status'] ?? false,
                        backgroundColor: const Color(0xFF191E29),
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
                        backgroundColor: (admin['Status'] ?? false)
                            ? const Color(0xFF696E79)
                            : const Color(0xFF01C38D),
                      ),
                      child: Text((admin['Status'] ?? false)
                          ? 'Unsubscribe'
                          : 'Subscribe'),
                      onPressed: () {
                        accountsCollection
                            .doc(admin.id)
                            .update({'Status': !(admin['Status'] ?? false)});
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.edit, color: Color(0xFF132D46)),
                      label: const Text('Edit',
                          style: TextStyle(color: Color(0xFF132D46))),
                      onPressed: () async {
                        String? editedName = await _editNameDialog(
                            context, admin['Name'] ?? 'Unknown');
                        if (editedName != null && editedName.isNotEmpty) {
                          accountsCollection
                              .doc(admin.id)
                              .update({'Name': editedName});
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

  Future<String?> _editNameDialog(
      BuildContext context, String currentName) async {
    TextEditingController _controller =
        TextEditingController(text: currentName);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name',
              style: TextStyle(color: Color(0xFF191E29))),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF696E79))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save',
                  style: TextStyle(color: Color(0xFF132D46))),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}
