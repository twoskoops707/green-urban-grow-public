import 'package:flutter/material.dart';
import 'plant_scanner.dart';

class GardenFeatures extends StatefulWidget {
  final PlantScanner? scanner;

  const GardenFeatures({super.key, this.scanner});

  @override
  _GardenFeaturesState createState() => _GardenFeaturesState();
}

class _GardenFeaturesState extends State<GardenFeatures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E7D32),
                      const Color(0xFF4CAF50).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.eco,
                        size: 64,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Garden Features',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Feature Cards
              _buildFeatureCard(
                icon: Icons.local_florist,
                title: 'Plant Scanner',
                subtitle: 'Identify plants with AI',
                color: const Color(0xFF4CAF50),
                onTap: () {
                  // Navigate to plant scanner
                },
              ),
              _buildFeatureCard(
                icon: Icons.calendar_today,
                title: 'Growth Tracker',
                subtitle: 'Monitor plant progress',
                color: const Color(0xFF8BC34A),
                onTap: () {
                  // Navigate to growth tracker
                },
              ),
              _buildFeatureCard(
                icon: Icons.water_drop,
                title: 'Watering Schedule',
                subtitle: 'Smart irrigation planning',
                color: const Color(0xFF2196F3),
                onTap: () {
                  // Navigate to watering schedule
                },
              ),
              _buildFeatureCard(
                icon: Icons.insights,
                title: 'Soil Analysis',
                subtitle: 'Nutrient and pH monitoring',
                color: const Color(0xFF795548),
                onTap: () {
                  // Navigate to soil analysis
                },
              ),
              _buildFeatureCard(
                icon: Icons.pest_control,
                title: 'Pest Management',
                subtitle: 'Identify and treat pests',
                color: const Color(0xFFF44336),
                onTap: () {
                  // Navigate to pest management
                },
              ),
              _buildFeatureCard(
                icon: Icons.seasonal_holiday,
                title: 'Seasonal Planning',
                subtitle: 'Year-round garden calendar',
                color: const Color(0xFFFF9800),
                onTap: () {
                  // Navigate to seasonal planning
                },
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new garden feature
        },
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
