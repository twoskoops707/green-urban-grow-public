import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  static const List<CommunityResource> resources = [
    CommunityResource(
      'Urban Gardening Subreddit',
      'https://reddit.com/r/UrbanGardening',
      'Tips for small space gardening'
    ),
    CommunityResource(
      'Balcony Gardening',
      'https://reddit.com/r/BalconyGardening', 
      'Container gardening discussions'
    ),
    CommunityResource(
      'Hydroponics Community',
      'https://reddit.com/r/Hydroponics',
      'Soil-free growing techniques'
    ),
    CommunityResource(
      'Window Farming',
      'https://reddit.com/r/WindowFarm',
      'Windowsill gardening ideas'
    ),
  ];

  Future<void> _launchReddit(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

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
                  'Connect with urban gardeners worldwide',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text('Share tips and get inspiration from the community'),
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
                    subtitle: Text(resource.description),
                    trailing: const Icon(Icons.open_in_new, semanticLabel: 'Open community'),
                    onTap: () => _launchReddit(resource.url),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityResource {
  final String name;
  final String url;
  final String description;

  const CommunityResource(this.name, this.url, this.description);
}
