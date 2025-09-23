import 'package:flutter/material.dart';
import 'garden_planner.dart';
import 'plant_library.dart';
import 'community.dart';
import 'care_reminders.dart';

void main() {
  runApp(const GreenUrbanGrowApp());
}

class GreenUrbanGrowApp extends StatelessWidget {
  const GreenUrbanGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Urban Grow',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFFF9FBE7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Urban Grow'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeatureCard(
            context,
            'AR Garden Planner',
            Icons.camera_alt,
            Colors.green,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GardenPlanner())),
          ),
          _buildFeatureCard(
            context,
            'Plant Library',
            Icons.local_florist,
            Colors.blue,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlantLibrary())),
          ),
          _buildFeatureCard(
            context,
            'Care Reminders',
            Icons.notifications,
            Colors.orange,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CareReminders())),
          ),
          _buildFeatureCard(
            context,
            'Community',
            Icons.people,
            Colors.purple,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Community())),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
