import 'package:flutter/material.dart';

class ForumCard extends StatelessWidget {
  final String title;
  final String creatorID;
  final VoidCallback onTap;

  const ForumCard({
    required this.title,
    required this.creatorID,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Text('by $creatorID'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
