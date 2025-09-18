import 'package:flutter/material.dart';
import 'plant_scanner.dart';
import 'garden_features.dart';

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
    _scannerFuture = PlantScanner.initialize();
    _scannerFuture!.then((scanner) {
      setState(() {
        _scanner = scanner;
        _pages.addAll([
          HomePage(scanner: _scanner!),
          GardenPlanner(),
          ShoppingList(),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_scanner == null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'GreenUrban Grow',
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_florist), label: 'Scanner'),
            BottomNavigationBarItem(
                icon: Icon(Icons.eco), label: 'Garden'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Shopping'),
          ],
        ),
      ),
    );
  }
}

// -------------------- HomePage / Plant Scanner UI --------------------
class HomePage extends StatefulWidget {
  final PlantScanner scanner;

  HomePage({required this.scanner});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isProcessing = false;
  File? _imageFile;
  String _result = '';

  final ImagePicker picker = ImagePicker();

  Future<void> _getImage(
      {required Permission permission,
      required ImageSource source,
      String errorMessage = 'Failed'}) async {
    final status = await permission.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied: $errorMessage')),
      );
      return;
    }

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile == null) return;

      setState(() => _isProcessing = true);

      final label = await widget.scanner.identifyPlant(pickedFile.path);
      final care = widget.scanner.getCareTips(label);

      setState(() {
        _imageFile = File(pickedFile.path);
        _result = '$label\n$care';
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$errorMessage: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickImage() async {
    await _getImage(
        permission: Permission.photos,
        source: ImageSource.gallery,
        errorMessage: 'Failed to pick image');
  }

  Future<void> _takePhoto() async {
    await _getImage(
        permission: Permission.camera,
        source: ImageSource.camera,
        errorMessage: 'Failed to take photo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plant Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: _isProcessing ? null : _pickImage,
                      child: Text(_isProcessing
                          ? 'Processing...'
                          : 'Select from Gallery')),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                      onPressed: _isProcessing ? null : _takePhoto,
                      child:
                          Text(_isProcessing ? 'Processing...' : 'Take Photo')),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _imageFile != null
                ? Image.file(_imageFile!)
                : Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey))),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
