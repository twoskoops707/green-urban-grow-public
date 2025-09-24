import 'package:flutter/material.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  static const List<CommunityResource> resources = [
    CommunityResource(
      'Urban Gardening Tips',
      'Small space gardening techniques',
      'Container gardening, vertical farming, balcony setups'
    ),
    CommunityResource(
      'Balcony Gardening', 
      'Making the most of limited space',
      'Compact plants, space-saving containers, micro-gardening'
    ),
    CommunityResource(
      'Hydroponics Basics',
      'Soil-free growing techniques',
      'Nutrient solutions, water conservation, indoor setups'
    ),
    CommunityResource(
      'Windowsill Gardening',
      'Maximizing indoor light',
      'Herb gardens, microgreens, light requirements'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gardening Community')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: const Column(
              children: [
                Text(
                  'Urban Gardening Community Resources',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text('Tips and techniques for small space gardening'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final resource = resources[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.people, color: Colors.orange, semanticLabel: 'Community icon'),
                    title: Text(resource.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(resource.description),
                        const SizedBox(height: 4),
                        Text(resource.details, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: const Icon(Icons.chat, semanticLabel: 'Community tips'),
                    onTap: () {
                      _showCommunityTips(context, resource);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCommunityTips(BuildContext context, CommunityResource resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resource.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(resource.description),
            const SizedBox(height: 10),
            Text(resource.details),
            const SizedBox(height: 10),
            const Text('Join online gardening communities to share experiences and learn from others!'),
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

class CommunityResource {
  final String name;
  final String description;
  final String details;

  const CommunityResource(this.name, this.description, this.details);
}
