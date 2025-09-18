import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final filePath = p.join(Directory.current.path, 'plans.json');
  List<Map<String, String>> plans = [];

  // Load existing plans if file exists
  final file = File(filePath);
  if (await file.exists()) {
    final content = await file.readAsString();
    if (content.isNotEmpty) {
      plans = List<Map<String, String>>.from(jsonDecode(content));
    }
  }

  print('Welcome to GreenUrban Grow Prototype!');
  print('1. Add new plan');
  print('2. List all plans');
  stdout.write('Choose option (1/2): ');
  final choice = stdin.readLineSync();

  if (choice == '1') {
    stdout.write('Enter space (e.g., balcony, windowsill): ');
    final space = stdin.readLineSync() ?? '';
    stdout.write('Enter sunlight (e.g., partial, full): ');
    final sunlight = stdin.readLineSync() ?? '';
    plans.add({'space': space, 'sunlight': sunlight});
    await file.writeAsString(jsonEncode(plans));
    print('Plan saved!');
  } else if (choice == '2') {
    if (plans.isEmpty) {
      print('No plans saved yet.');
    } else {
      print('Saved Plans:');
      for (var i = 0; i < plans.length; i++) {
        print('${i + 1}. Space: ${plans[i]['space']}, Sunlight: ${plans[i]['sunlight']}');
      }
    }
  } else {
    print('Invalid option.');
  }
}
