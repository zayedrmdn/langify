import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String name;
  final String role;
  final bool subscribed; // New parameter for subscription status
  final Color backgroundColor;

  UserDetailScreen({required this.name, required this.role, required this.subscribed, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name: $name',
                style: TextStyle(fontSize: 24, color: Color(0xFFFFFFFF)), // Text on dark backgrounds
              ),
              SizedBox(height: 10),
              Text(
                'Role: $role',
                style: TextStyle(fontSize: 24, color: Color(0xFFFFFFFF)), // Text on dark backgrounds
              ),
              SizedBox(height: 10),
              Text(
                'Subscription Status: ${subscribed ? 'Subscribed' : 'Unsubscribed'}', // Display subscription status
                style: TextStyle(fontSize: 24, color: Color(0xFFFFFFFF)), // Text on dark backgrounds
              ),
            ],
          ),
        ),
      ),
    );
  }
}
