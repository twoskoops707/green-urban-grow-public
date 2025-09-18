#!/bin/bash

# --- 1. Write main.dart ---
mkdir -p lib
cat > lib/main.dart << 'DMAIN'
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
              onPressed: () async {
                final scanner = await PlantScanner.initialize();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlantScannerPage(scanner: scanner)),
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
DMAIN

# --- 2. Write plant_scanner.dart ---
cat > lib/plant_scanner.dart << 'DPLANT'
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class PlantScanner {
  late Interpreter _interpreter;
  late List<String> _labels;
  late Map<String, String> _careTips;

  PlantScanner._internal();

  static Future<PlantScanner> initialize() async {
    final scanner = PlantScanner._internal();
    await scanner._loadModel();
    await scanner._loadLabels();
    await scanner._loadCareTips();
    return scanner;
  }

  Future<void> _loadModel() async {
    final interpreterOptions = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/model.tflite', options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsData.split('\n').map((e) => e.trim()).toList();
  }

  Future<void> _loadCareTips() async {
    final careData = await rootBundle.loadString('assets/care_tips.json');
    final Map<String, dynamic> jsonMap = json.decode(careData) as Map<String, dynamic>;
    _careTips = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<String> identifyPlant(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return 'Invalid image';
      final resized = img.copyResize(image, width: 224, height: 224);

      // Normalize (ABGR -> RGB)
      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) => List.generate(
              3,
              (c) {
                final pixel = resized.getPixel(x, y);
                if (c == 0) return ((pixel & 0xFF)) / 255.0;         // Red
                if (c == 1) return ((pixel >> 8) & 0xFF) / 255.0;    // Green
                return ((pixel >> 16) & 0xFF) / 255.0;               // Blue
              },
            ),
          ),
        ),
      );

      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
      _interpreter.run(input, output);

      int maxIndex = 0;
      for (int i = 0; i < _labels.length; i++) {
        if (output[0][i] > output[0][maxIndex]) maxIndex = i;
      }
      return _labels.isNotEmpty ? _labels[maxIndex] : 'Unknown';
    } catch (e) {
      return 'Error identifying plant: $e';
    }
  }

  String getCareTips(String plant) {
    return _careTips[plant] ?? 'No care info available';
  }
}

class PlantScannerPage extends StatefulWidget {
  final PlantScanner scanner;
  const PlantScannerPage({required this.scanner, super.key});

  @override
  State<PlantScannerPage> createState() => _PlantScannerPageState();
}

class _PlantScannerPageState extends State<PlantScannerPage> {
  File? _imageFile;
  String _result = '';
  bool _isProcessing = false;

  Future<void> _getImage({required ImageSource source}) async {
    setState(() => _isProcessing = true);
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 50, maxWidth: 1024, maxHeight: 1024);
      if (pickedFile == null) return;
      _imageFile = File(pickedFile.path);
      final label = await widget.scanner.identifyPlant(pickedFile.path);
      final care = widget.scanner.getCareTips(label);
      setState(() => _result = '$label\n\n$care');
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Scanner')),
      body: Column(
        children: [
          Expanded(
            child: _imageFile != null
                ? Image.file(_imageFile!)
                : Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all()),
                    child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
          ),
          const SizedBox(height: 16),
          if (_isProcessing) const CircularProgressIndicator(),
          ElevatedButton(
              onPressed: () => _getImage(source: ImageSource.gallery),
              child: const Text('Pick from Gallery')),
          ElevatedButton(
              onPressed: () => _getImage(source: ImageSource.camera),
              child: const Text('Take Photo')),
          const SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: Text(_result))),
        ],
      ),
    );
  }
}
DPLANT

# --- 3. Create shopping_list.dart ---
cat > lib/shopping_list.dart << 'DSHOP'
import 'package:flutter/material.dart';

class ShoppingList extends StatelessWidget {
  const ShoppingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: const Center(child: Text('Shopping list feature coming soon')),
    );
  }
}
DSHOP

# --- 4. Create garden_planner.dart ---
cat > lib/garden_planner.dart << 'DGARDEN'
import 'package:flutter/material.dart';

class GardenPlanner extends StatelessWidget {
  const GardenPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garden Planner')),
      body: const Center(child: Text('Garden planner feature coming soon')),
    );
  }
}
DGARDEN

# --- 5. Update pubspec.yaml ---
cat > pubspec.yaml << 'DPUB'
name: green_urban_grow
description: Auto plant scan MVP offline
version: 0.0.1
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  path: ^1.8.2
  tflite_flutter: ^0.10.0
  image: ^4.0.15
  permission_handler: ^11.0.1
  image_picker: ^0.8.7+5

flutter:
  uses-material-design: true
  assets:
    - assets/model.tflite
    - assets/labels.txt
    - assets/care_tips.json
DPUB

# --- 6. Create assets folder and placeholder files ---
mkdir -p assets
touch assets/model.tflite
cd ~/green-urban-grow && cat > setup_all.sh << 'EOF'
#!/bin/bash

# --- 1. Write main.dart ---
mkdir -p lib
cat > lib/main.dart << 'DMAIN'
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
              onPressed: () async {
                final scanner = await PlantScanner.initialize();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlantScannerPage(scanner: scanner)),
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
DMAIN

# --- 2. Write plant_scanner.dart ---
cat > lib/plant_scanner.dart << 'DPLANT'
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class PlantScanner {
  late Interpreter _interpreter;
  late List<String> _labels;
  late Map<String, String> _careTips;

  PlantScanner._internal();

  static Future<PlantScanner> initialize() async {
    final scanner = PlantScanner._internal();
    await scanner._loadModel();
    await scanner._loadLabels();
    await scanner._loadCareTips();
    return scanner;
  }

  Future<void> _loadModel() async {
    final interpreterOptions = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset('assets/model.tflite', options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsData.split('\n').map((e) => e.trim()).toList();
  }

  Future<void> _loadCareTips() async {
    final careData = await rootBundle.loadString('assets/care_tips.json');
    final Map<String, dynamic> jsonMap = json.decode(careData) as Map<String, dynamic>;
    _careTips = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<String> identifyPlant(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return 'Invalid image';
      final resized = img.copyResize(image, width: 224, height: 224);

      // Normalize (ABGR -> RGB)
      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) => List.generate(
              3,
              (c) {
                final pixel = resized.getPixel(x, y);
                if (c == 0) return ((pixel & 0xFF)) / 255.0;         // Red
                if (c == 1) return ((pixel >> 8) & 0xFF) / 255.0;    // Green
                return ((pixel >> 16) & 0xFF) / 255.0;               // Blue
              },
            ),
          ),
        ),
      );

      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
      _interpreter.run(input, output);

      int maxIndex = 0;
      for (int i = 0; i < _labels.length; i++) {
        if (output[0][i] > output[0][maxIndex]) maxIndex = i;
      }
      return _labels.isNotEmpty ? _labels[maxIndex] : 'Unknown';
    } catch (e) {
      return 'Error identifying plant: $e';
    }
  }

  String getCareTips(String plant) {
    return _careTips[plant] ?? 'No care info available';
  }
}

class PlantScannerPage extends StatefulWidget {
  final PlantScanner scanner;
  const PlantScannerPage({required this.scanner, super.key});

  @override
  State<PlantScannerPage> createState() => _PlantScannerPageState();
}

class _PlantScannerPageState extends State<PlantScannerPage> {
  File? _imageFile;
  String _result = '';
  bool _isProcessing = false;

  Future<void> _getImage({required ImageSource source}) async {
    setState(() => _isProcessing = true);
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 50, maxWidth: 1024, maxHeight: 1024);
      if (pickedFile == null) return;
      _imageFile = File(pickedFile.path);
      final label = await widget.scanner.identifyPlant(pickedFile.path);
      final care = widget.scanner.getCareTips(label);
      setState(() => _result = '$label\n\n$care');
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Scanner')),
      body: Column(
        children: [
          Expanded(
            child: _imageFile != null
                ? Image.file(_imageFile!)
                : Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all()),
                    child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
          ),
          const SizedBox(height: 16),
          if (_isProcessing) const CircularProgressIndicator(),
          ElevatedButton(
              onPressed: () => _getImage(source: ImageSource.gallery),
              child: const Text('Pick from Gallery')),
          ElevatedButton(
              onPressed: () => _getImage(source: ImageSource.camera),
              child: const Text('Take Photo')),
          const SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: Text(_result))),
        ],
      ),
    );
  }
}
DPLANT

# --- 3. Create shopping_list.dart ---
cat > lib/shopping_list.dart << 'DSHOP'
import 'package:flutter/material.dart';

class ShoppingList extends StatelessWidget {
  const ShoppingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: const Center(child: Text('Shopping list feature coming soon')),
    );
  }
}
DSHOP

# --- 4. Create garden_planner.dart ---
cat > lib/garden_planner.dart << 'DGARDEN'
import 'package:flutter/material.dart';

class GardenPlanner extends StatelessWidget {
  const GardenPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garden Planner')),
      body: const Center(child: Text('Garden planner feature coming soon')),
    );
  }
}
DGARDEN

# --- 5. Update pubspec.yaml ---
cat > pubspec.yaml << 'DPUB'
name: green_urban_grow
description: Auto plant scan MVP offline
version: 0.0.1
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  path: ^1.8.2
  tflite_flutter: ^0.10.0
  image: ^4.0.15
  permission_handler: ^11.0.1
  image_picker: ^0.8.7+5

flutter:
  uses-material-design: true
  assets:
    - assets/model.tflite
    - assets/labels.txt
    - assets/care_tips.json
DPUB

# --- 6. Create assets folder and placeholder files ---
mkdir -p assets
touch assets/model.tflite


