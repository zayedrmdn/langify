import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:langify/Admin/Admin.dart';
import 'package:langify/Learner/home_page.dart';
import 'package:langify/screens/signin_screen.dart';
import 'package:langify/screens/chat_screen.dart'; // Import the ChatScreen
import 'package:langify/Expert/Expert_main.dart';
import 'package:langify/screens/translator_screen.dart';
import 'package:langify/Learner/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Go to Learner main"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ElevatedButton(
              child: const Text("Go to Expert main"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExpertMain()));
              },
            ),
            ElevatedButton(
              child: const Text("Go to Admin Main"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()));
              },
            ),
            ElevatedButton(
              child: const Text("Go to Expert main"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExpertMain()));
              },
            ),
            ElevatedButton(
              child: const Text("Go Translator"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TranslatorScreen()));
              },
            ),
            ElevatedButton(
              child: const Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
