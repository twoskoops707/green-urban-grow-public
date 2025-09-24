import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class GardenPlanner extends StatelessWidget {
  const GardenPlanner({super.key});
  final List<Map<String,String>> products = const [
    {'name':'Indoor Hydroponic Kit','url':'https://www.amazon.com/dp/B08XYZ123?tag=greenurban08-20','image':'https://images-na.ssl-images-amazon.com/images/I/81example.jpg'},
    {'name':'Vertical Garden Planter','url':'https://www.amazon.com/dp/B07ABC456?tag=greenurban08-20','image':'https://images-na.ssl-images-amazon.com/images/I/91example.jpg'},
    {'name':'LED Grow Light','url':'https://www.amazon.com/dp/B09GROW789?tag=greenurban08-20','image':'https://images-na.ssl-images-amazon.com/images/I/71example.jpg'}
  ];
  Future<void> _launchURL(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if(await canLaunchUrl(uri)){ await launchUrl(uri,mode:LaunchMode.externalApplication); }
    else{ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open product link')));}
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('AR Garden Planner')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context,index){
          final product=products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal:10,vertical:5),
            child: ListTile(
              leading: product['image']!=null ? Image.network(product['image']!,width:60,fit:BoxFit.cover):const Icon(Icons.shopping_bag,size:40),
              title: Text(product['name'] ?? 'Unknown Product'),
              trailing: const Icon(Icons.open_in_new),
              onTap: (){ if(product['url']!=null) _launchURL(product['url']!,context); },
            ),
          );
        },
      ),
    );
  }
}
