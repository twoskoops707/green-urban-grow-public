import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class PlantScanner {
  late Interpreter _interpreter;
  List<String> _labels = [];

  PlantScanner._();

  static Future<PlantScanner> initialize() async {
    final scanner = PlantScanner._();
    await scanner._loadModel();
    await scanner._loadLabels();
    return scanner;
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  Future<void> _loadLabels() async {
    final careData = await File('assets/labels.txt').readAsString();
    _labels = careData.split('\n');
  }

  Future<String> identifyPlant(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(image, width: 224, height: 224);
    var input = List.generate(1, (_) => List.generate(224, (_) => List.filled(224*3, 0.0)));

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        input[0][y][x*3+0] = ((pixel) & 0xFF) / 255.0; // Red
        input[0][y][x*3+1] = ((pixel >> 8) & 0xFF) / 255.0; // Green
        input[0][y][x*3+2] = ((pixel >> 16) & 0xFF) / 255.0; // Blue
      }
    }

    var output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter.run(input, output);
    final index = output[0].indexOf(output[0].reduce((a,b)=>a>b?a:b));
    return _labels.isNotEmpty ? _labels[index] : 'Unknown';
  }
}

class PlantScannerPage extends StatelessWidget {
  final PlantScanner scanner;
  const PlantScannerPage({required this.scanner, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Plant Scanner')), body: Container());
  }
}
