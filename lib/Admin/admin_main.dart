import 'package:flutter/material.dart';
import 'track_progress_page.dart';
import 'user_list_page.dart';
import 'subscription_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Main Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FeatureButton(
              icon: Icons.bar_chart,
              title: 'Track Progress',
              color: Colors.blue,
              onTap: () => _navigateToPage(context, TrackProgressPage()),
            ),
            SizedBox(height: 16.0),
            FeatureButton(
              icon: Icons.subscriptions,
              title: 'Subscription',
              color: Colors.blue,
              onTap: () => _navigateToPage(context, SubscriptionPage()),
            ),
            SizedBox(height: 16.0),
            FeatureButton(
              icon: Icons.edit,
              title: 'Edit User',
              color: Colors.blue,
              onTap: () => _navigateToPage(context, UserListPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  FeatureButton(
      {required this.icon,
      required this.title,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
