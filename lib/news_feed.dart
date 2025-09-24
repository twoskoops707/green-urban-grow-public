import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  List articles = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = 'greenurban08-20'; // Inline key from notes
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=urban%20gardening%20OR%20hydroponics%20OR%20indoor%20farming%20OR%20vertical%20gardens&language=en&sortBy=publishedAt&apiKey=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = data['articles'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load news (Code: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching news: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (articles.isEmpty) {
      return const Center(child: Text('No news articles available.'));
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: article['urlToImage'] != null
                ? Image.network(article['urlToImage'], width: 60, fit: BoxFit.cover)
                : const Icon(Icons.article, size: 40),
            title: Text(article['title'] ?? 'No title'),
            subtitle: Text(article['source']?['name'] ?? 'Unknown source'),
            onTap: () {
              if (article['url'] != null) {
                _launchURL(article['url']);
              }
            },
          ),
        );
      },
    );
  }
}
