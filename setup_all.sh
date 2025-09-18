#!/bin/bash

# Create plant_scanner.dart
cat > lib/plant_scanner.dart << 'PLANT'
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

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
    _interpreter = await Interpreter.fromAsset('model.tflite');
  }

  Future<void> _loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsData.split('\n').map((e) => e.trim()).toList();
  }

  Future<void> _loadCareTips() async {
    final careData = await rootBundle.loadString('assets/care_tips.json');
    final Map<String, dynamic> jsonMap = json.decode(careData);
    _careTips = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<String> identifyPlant(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return 'Invalid image';
      final resized = img.copyResize(image, width: 224, height: 224);

      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) => List.generate(
              3,
              (c) => (resized.getPixel(x, y) >> (16 - (c * 8)) & 0xFF) / 255.0,
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
      return _labels[maxIndex];
    } catch (e) {
      return 'Error identifying plant: $e';
    }
  }

  String getCareTips(String plant) {
    return _careTips[plant] ?? 'No care info available';
  }
}
PLANT

# Create main.dart
cat > lib/main.dart << 'MAIN'
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'plant_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<PlantScanner>? _scannerFuture;

  @override
  void initState() {
    super.initState();
    _scannerFuture = PlantScanner.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenUrban Grow',
      home: FutureBuilder<PlantScanner>(
        future: _scannerFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(scanner: snapshot.data!);
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final PlantScanner scanner;
  HomePage({required this.scanner});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  String _result = '';
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage({
    required Permission permission,
    required ImageSource source,
    required String errorMessage,
  }) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final status = await permission.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied')),
      );
      setState(() => _isProcessing = false);
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile == null) return;

      final label = await widget.scanner.identifyPlant(pickedFile.path);
      final care = widget.scanner.getCareTips(label);

      setState(() {
        _imageFile = File(pickedFile.path);
        _result = '$label\n$care';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$errorMessage: $e')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickImage() async {
    await _getImage(
      permission: Permission.photos,
      source: ImageSource.gallery,
      errorMessage: 'Failed to pick image',
    );
  }

  Future<void> _takePhoto() async {
    await _getImage(
      permission: Permission.camera,
      source: ImageSource.camera,
      errorMessage: 'Failed to take photo',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenUrban Grow')),
      body: Column(
        children: [
          _imageFile != null
              ? Image.file(_imageFile!)
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isProcessing ? null : _pickImage,
                child: Text(_isProcessing ? 'Processing...' : 'Select Image'),
              ),
              ElevatedButton(
                onPressed: _isProcessing ? null : _takePhoto,
                child: Text(_isProcessing ? 'Processing...' : 'Take Photo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_result, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
MAIN

# Create pubspec.yaml
cat > pubspec.yaml << 'PUBSPEC'
name: green_urban_grow
description: Auto plant scan MVP offline
version: 0.0.1
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.10.0
  image: ^4.0.15
  image_picker: ^1.0.4
  permission_handler: ^11.0.1

flutter:
  assets:
    - assets/model.tflite
    - assets/labels.txt
    - assets/care_tips.json
PUBSPEC

