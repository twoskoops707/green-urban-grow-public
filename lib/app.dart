import 'package:flutter/material.dart';
import 'plant_scanner.dart';
import 'garden_features.dart';
import 'garden_planner.dart';
import 'main_menu.dart';

void main() {
  runApp(GreenUrbanGrowApp());
}

class GreenUrbanGrowApp extends StatefulWidget {
  @override
  _GreenUrbanGrowAppState createState() => _GreenUrbanGrowAppState();
}

class _GreenUrbanGrowAppState extends State<GreenUrbanGrowApp> {
  Future<PlantScanner>? _scannerFuture;
  int _currentIndex = 0;
  final List<Widget> _pages = [];
  PlantScanner? _scanner;

  @override
  void initState() {
    super.initState();
    _scannerFuture = PlantScanner.create();
    _scannerFuture!.then((scanner) {
      setState(() {
        _scanner = scanner;
        _pages.addAll([
          MainMenu(scanner: scanner),
          GardenPlanner(scanner: scanner),
          GardenFeatures(scanner: scanner),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Urban Grow',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        hintColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 6,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(12),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          buttonColor: const Color(0xFF4CAF50),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF388E3C),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC8E6C9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1B5E20),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🌱 Green Urban Grow'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                // Add info dialog
              },
            ),
          ],
        ),
        body: FutureBuilder<PlantScanner>(
          future: _scannerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cultivating Your Garden...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to initialize garden tools',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _scannerFuture = PlantScanner.create();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return _pages.isEmpty
                  ? const Center(
                      child: Text(
                        'No garden features available',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : _pages[_currentIndex];
            }
          },
        ),
        bottomNavigationBar: _scanner == null
            ? null
            : Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedItemColor: const Color(0xFF2E7D32),
                  unselectedItemColor: Colors.grey[600],
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Planner',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.eco),
                      label: 'Features',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
