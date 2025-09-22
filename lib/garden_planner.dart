import 'package:flutter/material.dart';
import 'plant_scanner.dart';

class GardenPlanner extends StatelessWidget {
  final PlantScanner? scanner;
  const GardenPlanner({super.key, this.scanner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text('Garden Planner'),
        backgroundColor: Color(0xFF2E7D32),
      ),
      body: Center(
        child: Text(
          'Garden planning functionality',
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF2E7D32),
          ),
        ),
      ),
    );
  }
}
