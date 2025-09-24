import 'package:flutter/material.dart';
import 'garden_planner.dart';
import 'plant_library.dart';
import 'care_reminders.dart';
import 'community.dart';
import 'news_feed.dart';

void main() => runApp(GreenUrbanGrow());

class GreenUrbanGrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Urban Grow',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _currentIndex = 0;
  final _pages = [
    GardenPlanner(),
    PlantLibrary(),
    CareReminders(),
    Community(),
    NewsFeed(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.nature), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'News'),
        ],
      ),
    );
  }
}
