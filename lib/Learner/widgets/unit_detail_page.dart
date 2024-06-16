import 'package:flutter/material.dart';

class UnitDetailPage extends StatelessWidget {
  final Map<String, dynamic> unit;

  const UnitDetailPage({required this.unit, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unit['unitName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(unit['imageUrl']),
            const SizedBox(height: 16),
            Text(
              'Contents: ${unit['unitContent']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              unit['unitDescription'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Reference/Source: ${unit['unitURL']}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
