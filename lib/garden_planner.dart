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
      UrbanProduct('Royal Gold Soil', 'https://amzn.to/3zoXp89', '\$24.99', 'Premium container soil'),
      UrbanProduct('Vertical Planter', 'https://amzn.to/3TkLp12', '\$39.99', 'Space-saving design'),
      UrbanProduct('Self-Watering Pots', 'https://amzn.to/4fLmR89', '\$29.99', 'Reduces watering frequency'),
    ],
    'windowsill': [
      UrbanProduct('Windowsill Herb Kit', 'https://amzn.to/4dNvX89', '\$19.99', 'Complete starter set'),
      UrbanProduct('LED Grow Light', 'https://amzn.to/3zqYp12', '\$34.99', 'Low-energy plant light'),
      UrbanProduct('Mini Watering Can', 'https://amzn.to/4fKmR45', '\$12.99', 'Perfect for small spaces'),
    ],
    'vertical': [
      UrbanProduct('Wall Planter System', 'https://amzn.to/3TnMp23', '\$49.99', 'Modular vertical garden'),
      UrbanProduct('Pocket Planters', 'https://amzn.to/4dPvX67', '\$22.99', 'Felt wall planters'),
      UrbanProduct('Drip Irrigation Kit', 'https://amzn.to/3zoYq12', '\$45.99', 'Automatic watering'),
    ],
    'hydroponic': [
      UrbanProduct('Countertop Hydroponics', 'https://amzn.to/4fLmS90', '\$89.99', 'Soil-free growing'),
      UrbanProduct('Nutrient Solution', 'https://amzn.to/3TkMp34', '\$18.99', 'Essential plant food'),
      UrbanProduct('pH Testing Kit', 'https://amzn.to/3znXq56', '\$14.99', 'Maintain optimal levels'),
    ],
  };

  Future<void> _launchProduct(String url) async {
    final affiliateUrl = url.replaceAll('https://amzn.to/', 'https://www.amazon.com/dp/') + '?tag=$amazonAffiliateId';
    if (await canLaunchUrl(Uri.parse(affiliateUrl))) {
      await launchUrl(Uri.parse(affiliateUrl));
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: Colors.green[700]),
                  const SizedBox(height: 10),
                  const Text('AR Space Measurement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text('(Coming Soon - Camera-based area calculation)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Recommended Products
            const Text('Recommended Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...products.map((product) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.shopping_basket, color: Colors.green),
                title: Text(product.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.description),
                    Text(product.price, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchProduct(product.url),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class UrbanProduct {
  final String name;
  final String url;
  final String price;
  final String description;

  UrbanProduct(this.name, this.url, this.price, this.description);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
