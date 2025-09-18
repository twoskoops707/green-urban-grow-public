import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

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

  final imageFiles = imagesDir.listSync().whereType<File>().where((f) => 
    ['.jpg', '.jpeg', '.png'].contains(p.extension(f.path).toLowerCase())
  );

  if (imageFiles.isEmpty) {
    print('No images found in plant_images folder.');
    return;
  }

  // Loop through all images and identify plants
  for (var image in imageFiles) {
    print('Scanning: ${p.basename(image.path)}');

    final bytes = await image.readAsBytes();
    final uri = Uri.parse('https://my-api.plantnet.org/v2/identify/all?api-key=YOUR_API_KEY');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('images', bytes, filename: p.basename(image.path)));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(respStr);
      final plantName = data['results'] != null && data['results'].isNotEmpty
        ? data['results'][0]['species']['scientificNameWithoutAuthor'] ?? 'Unknown'
        : 'Unknown';
      print('Detected: $plantName');

      // Save to plans.json
      plans.add({'image': p.basename(image.path), 'plant': plantName});
      await file.writeAsString(jsonEncode(plans));
    } else {
      print('Error scanning ${p.basename(image.path)}: ${response.statusCode}');
    }
  }

  print('All scans complete. Plans saved in plans.json');
}
