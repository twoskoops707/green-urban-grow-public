import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/reddit_service.dart';
import 'services/content_service.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final String amazonAffiliateId = 'greenurban08-20';
  final RedditService _redditService = RedditService();
  final ContentService _contentService = ContentService();
  List<RedditPost> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommunityContent();
  }

  Future<void> _loadCommunityContent() async {
    final posts = await _redditService.fetchGardeningPosts();
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  Future<void> _launchAmazonProduct(String asin) async {
    final url = 'https://www.amazon.com/dp/$asin?tag=$amazonAffiliateId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _joinRedditCommunity() async {
    const url = 'https://www.reddit.com/r/GreenUrbanGrow';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Urban Grow Community'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadCommunityContent,
            tooltip: 'Refresh Posts',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _joinRedditCommunity,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Join Our Reddit Community',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Community Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green[50],
                  child: const Column(
                    children: [
                      Icon(Icons.eco, size: 40, color: Color(0xFF2E7D32)),
                      SizedBox(height: 8),
                      Text(
                        'Organic Urban Gardening Community',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Share organic gardening tips and connect with sustainable growers',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Reddit Posts
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return RedditPostCard(
                        post: post,
                        onProductTap: (plantType) {
                          final products = _contentService.getOrganicProducts(plantType);
                          _showOrganicProducts(context, products, plantType);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showOrganicProducts(BuildContext context, List<OrganicProduct> products, String plantType) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Recommended Organic Products for $plantType',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...products.map((product) => ListTile(
              leading: const Icon(Icons.eco, color: Colors.green),
              title: Text(product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.description),
                  Text('\$${product.price} • ${product.brand}'),
                ],
              ),
              trailing: const Icon(Icons.shopping_cart),
              onTap: () => _launchAmazonProduct(product.asin),
            )),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class RedditPostCard extends StatelessWidget {
  final RedditPost post;
  final Function(String) onProductTap;

  const RedditPostCard({super.key, required this.post, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getSubredditColor(post.subreddit),
                  child: Text(
                    post.subreddit[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'r/${post.subreddit}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.getTimeAgo(),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('${post.score} 👍'),
                  backgroundColor: Colors.green[50],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Post Content
            Text(
              post.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              post.body.length > 200 ? '${post.body.substring(0, 200)}...' : post.body,
              style: const TextStyle(fontSize: 14),
            ),
            
            // Organic Product Suggestions
            if (_containsGardeningKeywords(post.title + post.body)) ...[
              const SizedBox(height: 12),
              const Text(
                'Organic Product Suggestions:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _extractPlantTypes(post.title + post.body).map((plantType) {
                  return ActionChip(
                    avatar: const Icon(Icons.eco, size: 16),
                    label: Text(plantType),
                    onPressed: () => onProductTap(plantType),
                    backgroundColor: Colors.green[50],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSubredditColor(String subreddit) {
    final colors = [Colors.green, Colors.orange, Colors.blue, Colors.purple];
    return colors[subreddit.hashCode % colors.length];
  }

  bool _containsGardeningKeywords(String text) {
    final keywords = ['tomato', 'basil', 'lettuce', 'herb', 'vegetable', 'flower', 'plant', 'grow', 'soil', 'fertilizer'];
    return keywords.any((keyword) => text.toLowerCase().contains(keyword));
  }

  List<String> _extractPlantTypes(String text) {
    final plantTypes = ['tomatoes', 'basil', 'lettuce', 'herbs', 'vegetables', 'flowers'];
    return plantTypes.where((type) => text.toLowerCase().contains(type)).toList();
  }
}
