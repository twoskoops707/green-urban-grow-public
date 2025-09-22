import 'package:flutter/material.dart';
import 'plant_scanner.dart';

class MainMenu extends StatelessWidget {
  final PlantScanner? scanner;
  const MainMenu({super.key, this.scanner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 100, color: Color(0xFF2E7D32)),
            SizedBox(height: 20),
            Text(
              'Green Urban Grow',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Cultivate Your Urban Garden',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
