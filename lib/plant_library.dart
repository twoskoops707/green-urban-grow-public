import 'package:flutter/material.dart';

class PlantLibrary extends StatelessWidget {
  const PlantLibrary({super.key});

  static const List<Plant> plants = [
    Plant('Tomatoes', 'Balcony-friendly, needs 6+ hours sun', 'Solanum lycopersicum'),
    Plant('Basil', 'Perfect for windowsills, frequent harvesting', 'Ocimum basilicum'),
    Plant('Lettuce', 'Fast-growing, great for small spaces', 'Lactuca sativa'),
    Plant('Mint', 'Container-grown to prevent spreading', 'Mentha'),
    Plant('Microgreens', 'Harvest in 1-2 weeks, high nutrition', 'Various species'),
    Plant('Strawberries', 'Vertical planters save space', 'Fragaria × ananassa'),
    Plant('Chili Peppers', 'Compact varieties for containers', 'Capsicum annuum'),
    Plant('Herbs Collection', 'Windowsill herb garden basics', 'Various species'),
  ];

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
              leading: const Icon(Icons.local_florist, color: Colors.green, semanticLabel: 'Plant icon'),
              title: Text(plant.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.description),
                  const SizedBox(height: 4),
                  Text('Scientific: ${plant.scientificName}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              trailing: const Icon(Icons.info_outline, semanticLabel: 'Plant information'),
              onTap: () {
                _showPlantDetails(context, plant);
              },
            ),
          );
        },
      ),
    );
  }

  void _showPlantDetails(BuildContext context, Plant plant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plant.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scientific Name: ${plant.scientificName}'),
            const SizedBox(height: 10),
            Text(plant.description),
            const SizedBox(height: 10),
            const Text('For more detailed information, visit gardening websites or consult local experts.'),
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

class Plant {
  final String name;
  final String description;
  final String scientificName;

  const Plant(this.name, this.description, this.scientificName);
}
