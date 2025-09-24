import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GardenPlanner extends StatefulWidget {
  const GardenPlanner({super.key});

  @override
  _GardenPlannerState createState() => _GardenPlannerState();
}

class _GardenPlannerState extends State<GardenPlanner> {
  final String amazonAffiliateId = 'greenurban08-20';
  bool _isMeasuring = false;
  double _areaWidth = 0.0;
  double _areaHeight = 0.0;
  String _gardenType = 'vegetables';
  String _userExperience = 'beginner';
  List<AmazonProduct> _recommendedProducts = [];

  final Map<String, List<AmazonProduct>> _spaceProducts = {
    'balcony': [
      AmazonProduct('Royal Gold Soil', 'B08XYZ1234', '\$24.99', 'Premium potting mix for containers'),
      AmazonProduct('Vertical Planter', 'B09ABC5678', '\$39.99', '5-tier space-saving garden'),
      AmazonProduct('Self-Watering Pots', 'B07DEF9012', '\$29.99', '3-pack auto-watering containers'),
      AmazonProduct('Balcony Rail Planter', 'B08GHI3456', '\$19.99', 'Fits standard railings'),
    ],
    'windowsill': [
      AmazonProduct('Windowsill Herb Kit', 'B09JKL7890', '\$24.99', 'Complete starter kit with seeds'),
      AmazonProduct('LED Grow Light', 'B07MNO1234', '\$34.99', 'Full spectrum for indoor plants'),
      AmazonProduct('Mini Watering Can', 'B08PQR5678', '\$12.99', '0.5L precision watering'),
      AmazonProduct('Plant Mister', 'B09STU9012', '\$8.99', 'Fine spray for herbs'),
    ],
    'vertical': [
      AmazonProduct('Wall Planter System', 'B07VWX3456', '\$49.99', 'Modular vertical garden panels'),
      AmazonProduct('Pocket Planters', 'B08YZA7890', '\$22.99', '6-pack felt wall planters'),
      AmazonProduct('Drip Irrigation Kit', 'B09BCD1234', '\$45.99', 'Automatic watering system'),
      AmazonProduct('Vertical Garden Frame', 'B07EFG5678', '\$79.99', 'Sturdy metal structure'),
    ],
    'hydroponic': [
      AmazonProduct('Countertop Hydroponics', 'B08HIJ9012', '\$89.99', '6-pod indoor garden'),
      AmazonProduct('Nutrient Solution', 'B09KLM3456', '\$18.99', 'Complete plant food'),
      AmazonProduct('pH Testing Kit', 'B07NOP7890', '\$14.99', 'Digital pH meter'),
      AmazonProduct('Hydroponic Grow Tent', 'B08QRS1234', '\$129.99', '2x2ft complete setup'),
    ],
  };

  final Map<String, List<AmazonProduct>> _experienceProducts = {
    'beginner': [
      AmazonProduct('Gardening Starter Guide', 'B09TUV5678', '\$14.99', 'Urban gardening basics'),
      AmazonProduct('Soil Testing Kit', 'B07WXY9012', '\$18.99', '3-in-1 moisture/pH/light'),
      AmazonProduct('Beginner Tool Set', 'B08ZAB3456', '\$29.99', '5-piece essential tools'),
    ],
    'intermediate': [
      AmazonProduct('Advanced Pruning Shears', 'B09CDE7890', '\$24.99', 'Professional quality'),
      AmazonProduct('Compost Tumbler', 'B07FGH1234', '\$89.99', '65-gallon capacity'),
      AmazonProduct('Garden Planning Software', 'B08HIJ5678', '\$49.99', 'Digital garden designer'),
    ],
    'expert': [
      AmazonProduct('Professional Grow Lights', 'B09KLM9012', '\$199.99', 'Commercial quality LED'),
      AmazonProduct('Automated Irrigation', 'B07NOP3456', '\$149.99', 'Smart timer system'),
      AmazonProduct('Greenhouse Kit', 'B08QRS7890', '\$299.99', '6x8ft walk-in greenhouse'),
    ],
  };

  void _startMeasurement() {
    setState(() {
      _isMeasuring = true;
      _areaWidth = 10.0;
      _areaHeight = 8.0;
      _generateRecommendations();
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
    
    // Add space-specific products
    _recommendedProducts.addAll(_spaceProducts[_gardenType] ?? []);
    
    // Add experience-level products
    _recommendedProducts.addAll(_experienceProducts[_userExperience] ?? []);
    
    // Add type-specific bonus products
    if (_gardenType == 'vegetables') {
      _recommendedProducts.add(AmazonProduct(
        'Vegetable Seeds Collection', 'B09UVW1234', '\$19.99', '15 heirloom varieties'
      ));
    } else if (_gardenType == 'flowers') {
      _recommendedProducts.add(AmazonProduct(
        'Flower Fertilizer', 'B07XYZ5678', '\$16.99', 'Bloom booster formula'
      ));
    } else if (_gardenType == 'herbs') {
      _recommendedProducts.add(AmazonProduct(
        'Herb Drying Rack', 'B08ABC9012', '\$22.99', '5-tier drying system'
      ));
    }
  }

  Future<void> _launchAmazonProduct(String asin) async {
    final url = 'https://www.amazon.com/dp/$asin?tag=$amazonAffiliateId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _searchTopProducts() async {
    final query = 'top 10 products urban gardening $_gardenType $_userExperience';
    final url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Garden Planner'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _searchTopProducts,
            tooltip: 'Search Top Products',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Space Selection
            const Text('Select Your Growing Space:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ['balcony', 'windowsill', 'vertical', 'hydroponic'].map((space) {
                return FilterChip(
                  label: Text(space.capitalize()),
                  selected: _gardenType == space,
                  onSelected: (selected) => _setGardenGoals(space, _userExperience),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Experience Selection
            const Text('Your Experience Level:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 20),

            // AR Measurement
            if (!_isMeasuring) ...[
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
                    const Icon(Icons.camera_alt, size: 50, color: Colors.green),
                    const SizedBox(height: 10),
                    const Text('AR Space Measurement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _startMeasurement,
                      child: const Text('Start AR Measurement'),
                    ),
                  ],
                ),
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
                    Text('Perfect for $_gardenType gardening at $_userExperience level'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Recommended Products
            if (_recommendedProducts.isNotEmpty) ...[
              Row(
                children: [
                  const Text('Recommended Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: _searchTopProducts,
                    child: const Text('Search More →'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._recommendedProducts.map((product) => ProductCard(
                product: product,
                onTap: _launchAmazonProduct,
              )),
              
              // Affiliate Disclosure
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'As an Amazon Associate, we earn from qualifying purchases. Your support helps maintain this app.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AmazonProduct {
  final String name;
  final String asin;
  final String price;
  final String description;

  AmazonProduct(this.name, this.asin, this.price, this.description);
}

class ProductCard extends StatelessWidget {
  final AmazonProduct product;
  final Function(String) onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.shopping_basket, color: Colors.green, size: 30),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description),
            const SizedBox(height: 4),
            Text(product.price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => onTap(product.asin),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
