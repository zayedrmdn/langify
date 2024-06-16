import 'package:flutter/material.dart';

class ExpertProfilePage extends StatelessWidget {
  const ExpertProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for the expert profile
    final String imageUrl = 'https://via.placeholder.com/150';
    final String username = 'Aaz';
    final String email = 'ozz@gmail.com';

    return Scaffold(
      appBar: AppBar(
        title: Text('Expert Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 50.0,
            ),
            SizedBox(height: 20),
            Text(
              username,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              email,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}