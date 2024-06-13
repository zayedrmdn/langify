import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'track_progress_page.dart';
import 'user_list_page.dart';
import 'subscription_page.dart';
import 'video_page.dart';
import 'podcast_page.dart';
import 'music_page.dart';
import 'lesson_page.dart';
import 'feedback_page.dart';
import 'Admin.dart';
import 'Learner.dart';
import 'Experts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrated App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF132D46),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section 1: User Management
            SectionTitle(title: 'User Management'),
            FeatureButton(
              icon: Icons.person,
              title: 'Admin',
              color: Color(0xFF01C38D),
              onTap: () => _navigateToPage(context, AdminScreen()),
            ),
            FeatureButton(
              icon: Icons.person,
              title: 'Learner',
              color: Color(0xFF01C38D),
              onTap: () => _navigateToPage(context, LearnerScreen()),
            ),
            FeatureButton(
              icon: Icons.person,
              title: 'Experts',
              color: Color(0xFF01C38D),
              onTap: () => _navigateToPage(context, ExpertsScreen()),
            ),
            SizedBox(height: 20),
            // Section 2: Content Management
            SectionTitle(title: 'Content Management'),
            FeatureButton(
              icon: Icons.book,
              title: 'Lesson',
              color: Color(0xFF696E79),
              onTap: () => _navigateToPage(context, LessonPage()),
            ),
            FeatureButton(
              icon: Icons.music_note,
              title: 'Music',
              color: Color(0xFF696E79),
              onTap: () => _navigateToPage(context, MusicPage()),
            ),
            FeatureButton(
              icon: Icons.mic,
              title: 'Podcast',
              color: Color(0xFF696E79),
              onTap: () => _navigateToPage(context, PodcastPage()),
            ),
            FeatureButton(
              icon: Icons.video_library,
              title: 'Video',
              color: Color(0xFF696E79),
              onTap: () => _navigateToPage(context, VideoPage()),
            ),
            FeatureButton(
              icon: Icons.feedback,
              title: 'Feedback',
              color: Color(0xFF696E79),
              onTap: () => _navigateToPage(context, FeedbackPage()),
            ),
            SizedBox(height: 20),
            // Section 3: User Features
            SectionTitle(title: 'User Features'),
            FeatureButton(
              icon: Icons.bar_chart,
              title: 'Track Progress',
              color: Color(0xFF132D46),
              onTap: () => _navigateToPage(context, TrackProgressPage()),
            ),
            FeatureButton(
              icon: Icons.subscriptions,
              title: 'Subscription',
              color: Color(0xFF132D46),
              onTap: () => _navigateToPage(context, SubscriptionPage()),
            ),
            FeatureButton(
              icon: Icons.edit,
              title: 'Edit User',
              color: Color(0xFF132D46),
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

  FeatureButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
            Spacer(),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF132D46),
        ),
      ),
    );
  }
}
