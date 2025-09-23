import 'package:flutter/material.dart';

class GardenPlanner extends StatefulWidget {
  const GardenPlanner({super.key});

  @override
  _GardenPlannerState createState() => _GardenPlannerState();
}

class _GardenPlannerState extends State<GardenPlanner> {
  bool _isMeasuring = false;
  double _areaWidth = 0.0;
  double _areaHeight = 0.0;
  String _gardenType = '';
  String _userExperience = 'beginner';
  List<String> _recommendedProducts = [];

  void _startMeasurement() {
    setState(() {
      _isMeasuring = true;
      _areaWidth = 10.0;
      _areaHeight = 8.0;
    });
  }

  void _setGardenGoals(String type, String experience) {
    setState(() {
      _gardenType = type;
      _userExperience = experience;
      _generateRecommendations();
    });
  }

  void _generateRecommendations() {
    _recommendedProducts.clear();
    
    if (_gardenType == 'vegetables') {
      _recommendedProducts.addAll([
        'Raised Garden Bed Kit',
        'Organic Vegetable Seeds',
        'Compost Fertilizer',
        'Drip Irrigation System'
      ]);
    } else if (_gardenType == 'flowers') {
      _recommendedProducts.addAll([
        'Aeroponic Tower Garden',
        'Perennial Flower Seeds',
        'Flower Bed Edging',
        'Automatic Watering Timer'
      ]);
    } else if (_gardenType == 'herbs') {
      _recommendedProducts.addAll([
        'Vertical Herb Planter',
        'Herb Growing Kit',
        'Indoor Grow Lights',
        'Self-Watering Pots'
      ]);
    }

    if (_userExperience == 'beginner') {
      _recommendedProducts.add('Gardening Starter Guide');
      _recommendedProducts.add('Plant Care Mobile App Subscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Garden Planner'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AR Camera Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            if (!_isMeasuring) ...[
              ElevatedButton(
                onPressed: _startMeasurement,
                child: const Text('Start AR Measurement'),
              ),
              const SizedBox(height: 20),
            ],
            
            if (_isMeasuring) ...[
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.green[50],
                child: Column(
                  children: [
                    Text('Measured Area: ${_areaWidth}x${_areaHeight} feet',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('Set your garden goals:'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              const Text('What do you want to grow?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: ['vegetables', 'flowers', 'herbs'].map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: _gardenType == type,
                    onSelected: (selected) => _setGardenGoals(type, _userExperience),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 20),
              
              const Text('Gardening Experience?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: ['beginner', 'intermediate', 'expert'].map((exp) {
                  return FilterChip(
                    label: Text(exp),
                    selected: _userExperience == exp,
                    onSelected: (selected) => _setGardenGoals(_gardenType, exp),
                  );
                }).toList(),
              ),
              
              if (_recommendedProducts.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Recommended Products:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  children: _recommendedProducts.map((product) {
                    return ListTile(
                      leading: const Icon(Icons.shopping_cart, color: Colors.green),
                      title: Text(product),
                    );
                  }).toList(),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
