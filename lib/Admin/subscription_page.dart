import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final CollectionReference subscriptionsCollection = FirebaseFirestore.instance.collection('subscriptions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: StreamBuilder(
        stream: subscriptionsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var subscriptions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              var subscription = subscriptions[index];
              return ListTile(
                title: Text(subscription['user'], style: TextStyle(color: Color(0xFF191E29))),
                subtitle: Text('Status: ${subscription['status']}', style: TextStyle(color: Color(0xFF191E29))),
              );
            },
          );
        },
      ),
    );
  }
}
