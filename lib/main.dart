import 'package:flutter/material.dart';
import 'plant_scanner.dart';
import 'shopping_list.dart';
import 'garden_planner.dart';

void main() {
  runApp(const GreenUrbanGrowApp());
}

class GreenUrbanGrowApp extends StatelessWidget {
  const GreenUrbanGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenUrban Grow',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenUrban Grow')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlantScannerWidget()),
                );
              },
              child: const Text('Plant Scanner'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingList()),
                );
              },
              child: const Text('Shopping List'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GardenPlanner()),
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
