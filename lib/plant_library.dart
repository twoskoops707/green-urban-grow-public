import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantLibrary extends StatelessWidget {
  const PlantLibrary({super.key});

  final String amazonAffiliateId = 'greenurban08-20';

  static const List<Plant> plants = [
    Plant(
      'Tomatoes', 
      'Balcony-friendly, needs 6+ hours sun. Perfect for containers.',
      'Solanum lycopersicum',
      ['B08CXYQXYZ', 'B09ABCDEFG', 'B07TOMATO1'] // Amazon ASINs
    ),
    Plant(
      'Basil', 
      'Perfect for windowsills, frequent harvesting. Great for beginners.',
      'Ocimum basilicum', 
      ['B08HERB123', 'B09BASIL99', 'B07WINDOW1']
    ),
    Plant(
      'Lettuce', 
      'Fast-growing, great for small spaces. Harvest in 30 days.',
      'Lactuca sativa',
      ['B08LETUCE4', 'B09SALAD55', 'B07QUICKGR']
    ),
    Plant(
      'Mint', 
      'Container-grown to prevent spreading. Refreshing aroma.',
      'Mentha',
      ['B08MINT123', 'B09HERB456', 'B07CONTAIN']
    ),
    Plant(
      'Microgreens', 
      'Harvest in 1-2 weeks, high nutrition. Perfect for apartments.',
      'Various species',
      ['B08MICRO12', 'B09TRAY789', 'B07SEEDKIT']
    ),
    Plant(
      'Strawberries', 
      'Vertical planters save space. Sweet homegrown fruit.',
      'Fragaria × ananassa',
      ['B08BERRY34', 'B09VERTICAL', 'B07HANGING']
    ),
    Plant(
      'Chili Peppers', 
      'Compact varieties for containers. Adds spice to meals.',
      'Capsicum annuum',
      ['B08SPICY56', 'B09HOTPEPPER', 'B07POTGROW']
    ),
    Plant(
      'Herbs Collection', 
      'Windowsill herb garden basics. Fresh flavors daily.',
      'Various species',
      ['B08HERBSET', 'B09KITCHEN1', 'B07INDOORGR']
    ),
  ];

  Future<void> _launchAmazonProduct(String asin) async {
    final url = 'https://www.amazon.com/dp/$asin?tag=$amazonAffiliateId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _searchGoogleProducts(String plantName) async {
    final query = 'best products for growing $plantName urban gardening';
    final url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Urban Plant Library')),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return PlantCard(plant: plant, onAmazonTap: _launchAmazonProduct, onSearchTap: _searchGoogleProducts);
        },
      ),
    );
  }
}

class Plant {
  final String name;
  final String description;
  final String scientificName;
  final List<String> amazonAsins;

  const Plant(this.name, this.description, this.scientificName, this.amazonAsins);
}

class PlantCard extends StatelessWidget {
  final Plant plant;
  final Function(String) onAmazonTap;
  final Function(String) onSearchTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onAmazonTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_florist, color: Colors.green, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        plant.scientificName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plant.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            
            // Amazon Products Section
            const Text(
              'Recommended Products:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.amazonAsins.asMap().entries.map((entry) {
                final index = entry.key;
                final asin = entry.value;
                final productNames = [
                  'Growing Kit',
                  'Seeds/Pots',
                  'Care Supplies'
                ];
                return ActionChip(
                  avatar: const Icon(Icons.shopping_cart, size: 16),
                  label: Text(productNames[index]),
                  onPressed: () => onAmazonTap(asin),
                  backgroundColor: Colors.green[50],
                );
              }).toList(),
            ),
            
            const SizedBox(height: 12),
            
            // Google Search Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Search More Products Online'),
                onPressed: () => onSearchTap(plant.name),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
