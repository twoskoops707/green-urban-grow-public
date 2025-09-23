import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<AmazonProduct> _recommendedProducts = [];

  // YOUR ACTUAL AMAZON AFFILIATE ID
  final String amazonAffiliateId = 'greenurban08-20';

  void _startMeasurement() {
    setState(() {
      _isMeasuring = true;
      _areaWidth = 10.0; // Simulated measurement
      _areaHeight = 8.0;
    });
  }

  void _setGardenGoals(String type, String experience) {
    setState(() {
      _gardenType = type;
      _userExperience = experience;
      _generateAmazonRecommendations();
    });
  }

  void _generateAmazonRecommendations() {
    _recommendedProducts.clear();
    
    // Vegetable gardening products
    if (_gardenType == 'vegetables') {
      _recommendedProducts.addAll([
        AmazonProduct(
          'Raised Garden Bed Kit',
          'https://www.amazon.com/s?k=raised+garden+bed+kit&tag=$amazonAffiliateId',
          '\$89.99'
        ),
        AmazonProduct(
          'Organic Vegetable Seeds',
          'https://www.amazon.com/s?k=organic+vegetable+seeds&tag=$amazonAffiliateId',
          '\$12.99'
        ),
        AmazonProduct(
          'Compost Fertilizer',
          'https://www.amazon.com/s?k=organic+compost+fertilizer&tag=$amazonAffiliateId',
          '\$24.99'
        ),
        AmazonProduct(
          'Drip Irrigation System',
          'https://www.amazon.com/s?k=drip+irrigation+system&tag=$amazonAffiliateId',
          '\$45.99'
        ),
      ]);
    }
    // Flower gardening products  
    else if (_gardenType == 'flowers') {
      _recommendedProducts.addAll([
        AmazonProduct(
          'Aeroponic Tower Garden',
          'https://www.amazon.com/s?k=aeroponic+tower+garden&tag=$amazonAffiliateId',
          '\$299.99'
        ),
        AmazonProduct(
          'Perennial Flower Seeds',
          'https://www.amazon.com/s?k=perennial+flower+seeds&tag=$amazonAffiliateId',
          '\$15.99'
        ),
        AmazonProduct(
          'Flower Bed Edging',
          'https://www.amazon.com/s?k=flower+bed+edging&tag=$amazonAffiliateId',
          '\$34.99'
        ),
        AmazonProduct(
          'Automatic Watering Timer',
          'https://www.amazon.com/s?k=automatic+watering+timer&tag=$amazonAffiliateId',
          '\$29.99'
        ),
      ]);
    }
    // Herb gardening products
    else if (_gardenType == 'herbs') {
      _recommendedProducts.addAll([
        AmazonProduct(
          'Vertical Herb Planter',
          'https://www.amazon.com/s?k=vertical+herb+planter&tag=$amazonAffiliateId',
          '\$39.99'
        ),
        AmazonProduct(
          'Herb Growing Kit',
          'https://www.amazon.com/s?k=indoor+herb+growing+kit&tag=$amazonAffiliateId',
          '\$24.99'
        ),
        AmazonProduct(
          'Indoor Grow Lights',
          'https://www.amazon.com/s?k=indoor+grow+lights&tag=$amazonAffiliateId',
          '\$49.99'
        ),
        AmazonProduct(
          'Self-Watering Pots',
          'https://www.amazon.com/s?k=self+watering+pots&tag=$amazonAffiliateId',
          '\$19.99'
        ),
      ]);
    }

    // Beginner-specific products
    if (_userExperience == 'beginner') {
      _recommendedProducts.addAll([
        AmazonProduct(
          'Gardening Starter Guide Book',
          'https://www.amazon.com/s?k=gardening+for+beginners+book&tag=$amazonAffiliateId',
          '\$14.99'
        ),
        AmazonProduct(
          'Soil Testing Kit',
          'https://www.amazon.com/s?k=soil+testing+kit&tag=$amazonAffiliateId',
          '\$18.99'
        ),
      ]);
    }
  }

  Future<void> _launchAmazonProduct(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
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
            // AR Measurement Interface
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.square_foot, size: 50, color: Colors.green[700]),
                  const SizedBox(height: 10),
                  Text(
                    _isMeasuring 
                      ? 'Area: ${_areaWidth}x${_areaHeight} ft' 
                      : 'Point camera at garden area',
                    style: TextStyle(fontSize: 16, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            if (!_isMeasuring) ...[
              ElevatedButton.icon(
                onPressed: _startMeasurement,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Start AR Measurement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            if (_isMeasuring) ...[
              // Garden Goals Selection
              const Text('What do you want to grow?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: ['vegetables', 'flowers', 'herbs'].map((type) {
                  return FilterChip(
                    label: Text(type.capitalize()),
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
                    label: Text(exp.capitalize()),
                    selected: _userExperience == exp,
                    onSelected: (selected) => _setGardenGoals(_gardenType, exp),
                  );
                }).toList(),
              ),
              
              if (_recommendedProducts.isNotEmpty) ...[
                const SizedBox(height: 30),
                const Text('Recommended Amazon Products:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ..._recommendedProducts.map((product) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(Icons.shopping_basket, color: Colors.green),
                      title: Text(product.name),
                      subtitle: Text(product.price),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _launchAmazonProduct(product.amazonUrl),
                    ),
                  );
                }).toList(),
                
                // Affiliate Disclosure
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'As an Amazon Associate, Green Urban Grow earns from qualifying purchases. Your affiliate ID: $amazonAffiliateId',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class AmazonProduct {
  final String name;
  final String amazonUrl;
  final String price;

  AmazonProduct(this.name, this.amazonUrl, this.price);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
