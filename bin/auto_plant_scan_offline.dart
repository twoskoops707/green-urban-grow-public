import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<void> main() async {
  final imagesDir = Directory(p.join(Directory.current.path, 'plant_images'));
  final filePath = p.join(Directory.current.path, 'plans.json');

  // Make sure images folder exists
  if (!await imagesDir.exists()) {
    await imagesDir.create();
    print('Created plant_images folder. Put your images there and rerun.');
    return;
  }

  // Load existing plans
  List<Map<String, String>> plans = [];
  final file = File(filePath);
  if (await file.exists()) {
    final content = await file.readAsString();
    if (content.isNotEmpty) {
      plans = List<Map<String, String>>.from(jsonDecode(content));
    }
  }

  // Load TFLite model (place model.tflite in project root)
  final interpreter = await Interpreter.fromAsset('model.tflite');
  print('Model loaded successfully.');

  final imageFiles = imagesDir.listSync().whereType<File>().where((f) =>
      ['.jpg', '.jpeg', '.png'].contains(p.extension(f.path).toLowerCase()));

  if (imageFiles.isEmpty) {
    print('No images found in plant_images folder.');
    return;
  }

  for (var imageFile in imageFiles) {
    print('Scanning: ${p.basename(imageFile.path)}');

    // Load and preprocess image
    final rawImage = img.decodeImage(await imageFile.readAsBytes());
    if (rawImage == null) continue;
    final resizedImage = img.copyResize(rawImage, width: 224, height: 224);
    final input = List.generate(1, (i) => List.generate(224, (x) => List.generate(224, (y) {
      final pixel = resizedImage.getPixel(x, y);
      return [
        (img.getRed(pixel) / 255.0),
        (img.getGreen(pixel) / 255.0),
        (img.getBlue(pixel) / 255.0)
      ];
    })));

    // Prepare output buffer
    var output = List.filled(1001, 0.0).reshape([1, 1001]);

    // Run inference
    interpreter.run(input, output);

    // Get top prediction
    final topIndex = output[0].indexOf(output[0].reduce((curr, next) => curr > next ? curr : next));
    final plantName = 'Plant_$topIndex'; // You can map this index to actual labels.txt if available

    print('Detected: $plantName');

    // Save to plans.json
    plans.add({'image': p.basename(imageFile.path), 'plant': plantName});
    await file.writeAsString(jsonEncode(plans));
  }

  print('All scans complete. Plans saved in plans.json');
}
