import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  final String amazonAffiliateId = 'greenurban08-20';

  static const List<CommunityResource> resources = [
    CommunityResource(
      'Urban Gardening Subreddit',
      'https://reddit.com/r/UrbanGardening',
      '1.2M members sharing small-space tips',
      'Discussion about container gardening, balcony setups, space-saving techniques',
      ['B08CONTAIN', 'B09BALCONY1', 'B07SMALLSP']
    ),
    CommunityResource(
      'Hydroponics Community', 
      'https://reddit.com/r/Hydroponics',
      '850K hydroponic enthusiasts',
      'Soil-free growing, nutrient solutions, indoor systems',
      ['B08HYDROP1', 'B09NUTRIENT', 'B07LEDGROW']
    ),
    CommunityResource(
      'Balcony Gardening',
      'https://reddit.com/r/BalconyGardening',
      '150K balcony gardeners',
      'Maximizing limited outdoor space, container varieties',
      ['B08BALCONY2', 'B09RAILING', 'B07POTSTAND']
    ),
    CommunityResource(
      'Indoor Gardening',
      'https://reddit.com/r/IndoorGarden',
      '2.1M indoor plant lovers',
      'Lighting solutions, humidity control, pest management',
      ['B08INDOOR1', 'B09GROWLIGHT', 'B07HUMIDITY']
    ),
  ];

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _launchAmazonProduct(String asin) async {
    final url = 'https://www.amazon.com/dp/$asin?tag=$amazonAffiliateId';
    await _launchUrl(url);
  }

  Future<void> _searchCommunityProducts(String communityName) async {
    final query = 'best products recommended $communityName reddit';
    final url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
    await _launchUrl(url);
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
                  'Connect with Urban Gardeners Worldwide',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Learn from real experiences and discover recommended products',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final resource = resources[index];
                return CommunityResourceCard(
                  resource: resource,
                  onCommunityTap: _launchUrl,
                  onAmazonTap: _launchAmazonProduct,
                  onSearchTap: _searchCommunityProducts,
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
  final String members;
  final String description;
  final List<String> amazonAsins;

  const CommunityResource(
    this.name,
    this.url,
    this.members,
    this.description,
    this.amazonAsins,
  );
}

class CommunityResourceCard extends StatelessWidget {
  final CommunityResource resource;
  final Function(String) onCommunityTap;
  final Function(String) onAmazonTap;
  final Function(String) onSearchTap;

  const CommunityResourceCard({
    super.key,
    required this.resource,
    required this.onCommunityTap,
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
                const Icon(Icons.people, color: Colors.orange, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        resource.members,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              resource.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            
            // Community Recommended Products
            const Text(
              'Community Recommended:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resource.amazonAsins.map((asin) {
                return ActionChip(
                  avatar: const Icon(Icons.thumb_up, size: 14),
                  label: const Text('Popular Pick'),
                  onPressed: () => onAmazonTap(asin),
                  backgroundColor: Colors.orange[50],
                  labelStyle: const TextStyle(fontSize: 12),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.forum, size: 16),
                    label: const Text('Join Community'),
                    onPressed: () => onCommunityTap(resource.url),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.search, size: 16),
                    label: const Text('Find Products'),
                    onPressed: () => onSearchTap(resource.name),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
