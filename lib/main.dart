import 'package:flutter/material.dart';
import 'garden_planner.dart';
import 'plant_library.dart';
import 'care_reminders.dart';
import 'community.dart';
import 'news_feed.dart';

void main() {
  runApp(const GreenUrbanGrowApp());
}

class GreenUrbanGrowApp extends StatelessWidget {
  const GreenUrbanGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Urban Grow',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    GardenPlanner(),
    PlantLibrary(),
    CareReminders(),
    Community(),
    NewsFeed(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.yard), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
