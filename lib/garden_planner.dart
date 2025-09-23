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
  String _gardenType = 'vegetables';
  String _spaceType = 'balcony';

  final Map<String, List<UrbanProduct>> _productRecommendations = {
    'balcony': [
      UrbanProduct('Royal Gold Soil', 'B08XYZ1234', '\$24.99', 'Premium container soil'),
      UrbanProduct('Vertical Planter', 'B09ABC5678', '\$39.99', 'Space-saving design'),
      UrbanProduct('Self-Watering Pots', 'B07DEF9012', '\$29.99', 'Reduces watering frequency'),
    ],
    'windowsill': [
      UrbanProduct('Windowsill Herb Kit', 'B08GHI3456', '\$19.99', 'Complete starter set'),
      UrbanProduct('LED Grow Light', 'B09JKL7890', '\$34.99', 'Low-energy plant light'),
      UrbanProduct('Mini Watering Can', 'B07MNO1234', '\$12.99', 'Perfect for small spaces'),
    ],
    'vertical': [
      UrbanProduct('Wall Planter System', 'B08PQR5678', '\$49.99', 'Modular vertical garden'),
      UrbanProduct('Pocket Planters', 'B09STU9012', '\$22.99', 'Felt wall planters'),
      UrbanProduct('Drip Irrigation Kit', 'B07VWX3456', '\$45.99', 'Automatic watering'),
    ],
    'hydroponic': [
      UrbanProduct('Countertop Hydroponics', 'B08YZA7890', '\$89.99', 'Soil-free growing'),
      UrbanProduct('Nutrient Solution', 'B09BCD1234', '\$18.99', 'Essential plant food'),
      UrbanProduct('pH Testing Kit', 'B07EFG5678', '\$14.99', 'Maintain optimal levels'),
    ],
  };

  Future<void> _launchProduct(String asin) async {
    final url = 'https://www.amazon.com/dp/$asin?tag=$amazonAffiliateId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _productRecommendations[_spaceType] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Urban Garden Planner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Space Type Selection
            const Text('Your Growing Space:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ['balcony', 'windowsill', 'vertical', 'hydroponic'].map((space) {
                return FilterChip(
                  label: Text(space.capitalize()),
                  selected: _spaceType == space,
                  onSelected: (selected) => setState(() => _spaceType = space),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // AR Measurement Section
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: Colors.green, semanticLabel: 'AR camera'),
                  SizedBox(height: 10),
                  Text('AR Space Measurement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('(Coming Soon - Camera-based area calculation)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recommended Products
            const Text('Recommended Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...products.map((product) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.shopping_basket, color: Colors.green, semanticLabel: 'Product'),
                title: Text(product.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.description),
                    const SizedBox(height: 4),
                    Text(product.price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, semanticLabel: 'View product'),
                onTap: () => _launchProduct(product.asin),
              ),
            )).toList(),

            // Affiliate Disclosure
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'As an Amazon Associate, we earn from qualifying purchases. Product prices may vary.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UrbanProduct {
  final String name;
  final String asin;
  final String price;
  final String description;

  UrbanProduct(this.name, this.asin, this.price, this.description);
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
