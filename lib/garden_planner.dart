import 'package:flutter/material.dart';

class GardenPlanner extends StatefulWidget {
  const GardenPlanner({super.key});

  @override
  _GardenPlannerState createState() => _GardenPlannerState();
}

class _GardenPlannerState extends State<GardenPlanner> {
  String _spaceType = 'balcony';

  final Map<String, List<UrbanProduct>> _productRecommendations = {
    'balcony': [
      UrbanProduct('Royal Gold Soil', '\$24.99', 'Premium container soil for potted plants'),
      UrbanProduct('Vertical Planter', '\$39.99', 'Space-saving design for small areas'),
      UrbanProduct('Self-Watering Pots', '\$29.99', 'Reduces watering frequency'),
    ],
    'windowsill': [
      UrbanProduct('Windowsill Herb Kit', '\$19.99', 'Complete starter set for beginners'),
      UrbanProduct('LED Grow Light', '\$34.99', 'Low-energy plant light for indoors'),
      UrbanProduct('Mini Watering Can', '\$12.99', 'Perfect for small spaces'),
    ],
    'vertical': [
      UrbanProduct('Wall Planter System', '\$49.99', 'Modular vertical garden panels'),
      UrbanProduct('Pocket Planters', '\$22.99', 'Felt wall planters for herbs'),
      UrbanProduct('Drip Irrigation Kit', '\$45.99', 'Automatic watering system'),
    ],
    'hydroponic': [
      UrbanProduct('Countertop Hydroponics', '\$89.99', 'Soil-free growing system'),
      UrbanProduct('Nutrient Solution', '\$18.99', 'Essential plant food mix'),
      UrbanProduct('pH Testing Kit', '\$14.99', 'Maintain optimal water levels'),
    ],
  };

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
                trailing: const Icon(Icons.info_outline, size: 20, semanticLabel: 'Product info'),
                onTap: () {
                  _showProductInfo(context, product);
                },
              ),
            )).toList(),

            // Note about online shopping
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'These products are commonly available at garden centers or online retailers. Prices are approximate.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductInfo(BuildContext context, UrbanProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: ${product.price}'),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 10),
            const Text('Available at garden centers and online retailers.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class UrbanProduct {
  final String name;
  final String price;
  final String description;

  UrbanProduct(this.name, this.price, this.description);
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
