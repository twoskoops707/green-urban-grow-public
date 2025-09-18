import 'dart:io';
import 'dart:convert';
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
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  Future<void> _loadLabels() async {
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    _labels = labelsData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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

      final input = List.generate(1, (_) => List.generate(224, (y) =>
        List.generate(224, (x) => List.generate(3, (c) {
          final pixel = resized.getPixel(x, y);
          switch(c){
            case 0: return ((pixel) & 0xFF) / 255.0; // Red
            case 1: return ((pixel >> 8) & 0xFF) / 255.0; // Green
            case 2: return ((pixel >> 16) & 0xFF) / 255.0; // Blue
            default: return 0.0;
          }
        })))));

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

  String getCareTips(String plant) => _careTips[plant] ?? 'No care info available';
}
