import 'package:flutter/material.dart';
import 'plant_scanner_page.dart';
import 'shopping_list.dart';
import 'garden_planner.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenUrban Grow')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlantScannerPage()),
                );
              },
              child: const Text('Plant Scanner'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingList()),
                );
              },
              child: const Text('Shopping List'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GardenPlanner()),
                );
              },
              child: const Text('Garden Planner'),
            ),
          ],
        ),
      ),
    );
  }
}
