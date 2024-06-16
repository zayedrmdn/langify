import 'package:flutter/material.dart';

class EditBioPage extends StatefulWidget {
  final String initialBio;

  const EditBioPage({required this.initialBio, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditBioPageState createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.initialBio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bio'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Implement Firestore update logic here
              String updatedBio = _bioController.text.trim();
              // Save updatedBio to Firestore for the current user

              // Navigate back to ProfilePage after saving
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _bioController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Enter your bio',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }
}
