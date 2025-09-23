import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantLibrary extends StatelessWidget {
  const PlantLibrary({super.key});

  final List<Plant> plants = const [
    Plant('Tomatoes', 'https://en.wikipedia.org/wiki/Tomato', 'Balcony-friendly, needs 6+ hours sun'),
    Plant('Basil', 'https://en.wikipedia.org/wiki/Basil', 'Perfect for windowsills, frequent harvesting'),
    Plant('Lettuce', 'https://en.wikipedia.org/wiki/Lettuce', 'Fast-growing, great for small spaces'),
    Plant('Mint', 'https://en.wikipedia.org/wiki/Mint', 'Container-grown to prevent spreading'),
    Plant('Microgreens', 'https://en.wikipedia.org/wiki/Microgreen', 'Harvest in 1-2 weeks, high nutrition'),
    Plant('Strawberries', 'https://en.wikipedia.org/wiki/Strawberry', 'Vertical planters save space'),
    Plant('Chili Peppers', 'https://en.wikipedia.org/wiki/Chili_pepper', 'Compact varieties for containers'),
    Plant('Herbs', 'https://en.wikipedia.org/wiki/Herb', 'Windowsill herb garden basics'),
  ];

  Future<void> _launchWikipedia(String url) async {
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
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.local_florist, color: Colors.green),
              title: Text(plant.name),
              subtitle: Text(plant.description),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchWikipedia(plant.wikipediaUrl),
            ),
          );
        },
      ),
    );
  }
}

class Plant {
  final String name;
  final String wikipediaUrl;
  final String description;

  const Plant(this.name, this.wikipediaUrl, this.description);
}
