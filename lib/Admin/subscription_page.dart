import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // Mock data for user subscriptions
  final List<Map<String, dynamic>> _subscriptions = [
    {'name': 'John Doe', 'status': 'Subscribed'},
    {'name': 'Jane Smith', 'status': 'Subscribe'},
    {'name': 'Emily Johnson', 'status': 'Subscribed'},
    // Add more mock subscriptions as needed
  ];

  void _toggleSubscriptionStatus(int index) {
    setState(() {
      _subscriptions[index]['status'] =
          _subscriptions[index]['status'] == 'Subscribed' ? 'Subscribe' : 'Subscribed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _subscriptions.length,
        itemBuilder: (context, index) {
          final subscription = _subscriptions[index];
          return Card(
            child: ListTile(
              title: Text(subscription['name'], style: TextStyle(fontSize: 18)),
              trailing: GestureDetector(
                onTap: () => _toggleSubscriptionStatus(index),
                child: Chip(
                  label: Text(subscription['status']),
                  backgroundColor: subscription['status'] == 'Subscribed' ? Colors.green : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
