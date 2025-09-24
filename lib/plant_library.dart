import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/content_service.dart';

class PlantLibrary extends StatelessWidget {
  const PlantLibrary({super.key});

  final String amazonAffiliateId = 'greenurban08-20';
  final ContentService _contentService = ContentService();

  static const List<Plant> plants = [
    Plant('Tomatoes', 'Balcony-friendly, needs 6+ hours sun. Perfect for organic container gardening.', 'Solanum lycopersicum'),
    Plant('Basil', 'Perfect for windowsills, frequent harvesting. Great for organic pesto and cooking.', 'Ocimum basilicum'),
    Plant('Lettuce', 'Fast-growing, great for small spaces. Harvest organic greens in 30 days.', 'Lactuca sativa'),
    Plant('Mint', 'Container-grown to prevent spreading. Refreshing organic tea ingredient.', 'Mentha'),
    Plant('Microgreens', 'Harvest in 1-2 weeks, high nutrition. Perfect for organic urban farming.', 'Various species'),
    Plant('Strawberries', 'Vertical planters save space. Sweet organic homegrown fruit.', 'Fragaria × ananassa'),
    Plant('Chili Peppers', 'Compact varieties for containers. Adds organic spice to meals.', 'Capsicum annuum'),
    Plant('Herbs Collection', 'Windowsill organic herb garden. Fresh flavors for cooking.', 'Various species'),
  ];

  Future<void> _launchAmazonProduct(String asin) async {
    final url = 'https://www.amazon.com/dp/$asin?tag=$amazonAffiliateId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organic Plant Library'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          final organicProducts = _contentService.getOrganicProducts(plant.name);
          
          return PlantCard(
            plant: plant,
            organicProducts: organicProducts,
            onProductTap: _launchAmazonProduct,
          );
        },
      ),
    );
  }
}

class Plant {
  final String name;
  final String description;
  final String scientificName;

  const Plant(this.name, this.description, this.scientificName);
}

class PlantCard extends StatelessWidget {
  final Plant plant;
  final List<OrganicProduct> organicProducts;
  final Function(String) onProductTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.organicProducts,
    required this.onProductTap,
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
            // Plant Header
            Row(
              children: [
                const Icon(Icons.eco, color: Colors.green, size: 30),
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
                const Icon(Icons.organic, color: Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            
            // Plant Description
            Text(
              plant.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            
            // Organic Certification Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 14, color: Colors.green),
                  SizedBox(width: 4),
                  Text(
                    'Organic Recommended',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Organic Products
            const Text(
              'Certified Organic Products:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...organicProducts.take(3).map((product) => ListTile(
              leading: const Icon(Icons.eco, color: Colors.green),
              title: Text(product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.description),
                  Text('\$${product.price} • ${product.brand}'),
                ],
              ),
              trailing: const Icon(Icons.shopping_cart_checkout),
              onTap: () => onProductTap(product.asin),
              contentPadding: EdgeInsets.zero,
            )),
            
            const SizedBox(height: 12),
            
            // Organic Gardening Tips
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌱 Organic Gardening Tip:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Use compost and organic fertilizers to build healthy soil. Avoid synthetic chemicals to protect beneficial insects and soil life.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
