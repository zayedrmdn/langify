import 'package:flutter/material.dart';
import 'package:langify/Learner/forums_page.dart';
import 'package:langify/Learner/home_tab.dart';
import 'package:langify/Learner/profile_page.dart'; // Import your ProfilePage
import 'package:langify/Learner/leaderboard_page.dart';
import 'package:langify/Learner/puzzle_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    PuzzlePage(),
    LeaderboardPage(),
    HomeTab(),
    ForumsPage(
      currentUserID: 'Zayed', // This should be replaced with the actual user ID
    ),
    ProfilePage(
      currentUserID: 'Zayed', // Pass the currentUserID here
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learner Home'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'Puzzle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forums/Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
