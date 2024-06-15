import 'package:flutter/material.dart';
import '../puzzle_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YesButton extends StatelessWidget {
  const YesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Yes'),
    );
  }
}

String getUsername() {
  String username = '';
  // Open Firestore database and get the username
  FirebaseFirestore.instance
      .collection('Accounts')
      .doc('4bpbSGwea1Kh9J0eG5Ex')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      username = documentSnapshot.get('Username');
    } else {
      username = 'Anonymous';
    }
  });

  return username;
}
