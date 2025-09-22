import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'garden_planner.dart';
import 'garden_features.dart';

class GreenUrbanGrowApp extends StatelessWidget {
  const GreenUrbanGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Urban Grow',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
      ),
      home: const MainMenu(),
    );
  }
}
