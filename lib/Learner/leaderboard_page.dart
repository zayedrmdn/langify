import 'dart:math';

import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLeague("Bronze League", 5),
            Divider(height: 40, color: Colors.grey[600]),
            _buildLeague("Silver League", 5),
            Divider(height: 40, color: Colors.grey[600]),
            _buildLeague("Gold League", 5),
            Divider(height: 40, color: Colors.grey[600]),
            _buildLeague("Platinum League", 5),
          ],
        ),
      ),
    );
  }

  Widget _buildLeague(String leagueTitle, int numUsers) {
    List<UserData> users = _generateRandomUsers(numUsers);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          leagueTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        if (users.isNotEmpty)
          Column(
            children: users.map((user) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
                title: Text(user.username),
                subtitle: Text('${user.xp} XP'),
              );
            }).toList(),
          ),
        if (users.isEmpty)
          Center(
            child: Text('No users found'),
          ),
      ],
    );
  }

  List<UserData> _generateRandomUsers(int numUsers) {
    List<UserData> users = [];
    Random random = Random();

    for (int i = 0; i < numUsers; i++) {
      String username = _randomUsername(random);
      int xp = random.nextInt(500); // Random XP between 0 and 499
      users.add(UserData(username: username, xp: xp));
    }

    return users;
  }

  String _randomUsername(Random random) {
    List<String> names = [
      'Alice',
      'Bob',
      'Charlie',
      'David',
      'Eve',
      'Frank',
      'Grace',
      'Henry',
      'Ivy',
      'Jack',
      'Kate',
      'Leo',
      'Mia',
      'Noah',
      'Olivia',
      'Peter',
      'Quinn',
      'Rose',
      'Sam',
      'Tina',
      'Uma',
      'Victor',
      'Wendy',
      'Xavier',
      'Yara',
      'Zane'
    ];

    return names[random.nextInt(names.length)];
  }
}

class UserData {
  final String username;
  final int xp;

  UserData({required this.username, required this.xp});
}
