import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Handles file browsing on Flutter Web natively
import 'package:lucide_icons_flutter/lucide_icons.dart';

class KilimoScreen extends StatefulWidget {
  const KilimoScreen({super.key});

  @override
  State<KilimoScreen> createState() => _KilimoScreenState();
}

class _KilimoScreenState extends State<KilimoScreen> {
  XFile? _selectedImage; // Holds reference to the browsed file data
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  // Triggers browser file exploration window channel
  Future<void> _handleImageSelection() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint("Media Picker Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kilimo AI Advisor',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Precision agrotech telemetry & crop diagnostic systems.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.cloudSun, color: Color(0xFFF59E0B), size: 14),
                    SizedBox(width: 8),
                    Text(
                      'Optimal Planting Window',
                      style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Layout Builder for Telemetry Grid (Responsive)
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
                children: const [
                  AgriMetricCard(
                    title: 'Soil Moisture Level',
                    value: '42% (Optimal)',
                    subtitle: 'Sensor Node: Kenya-West-A3',
                    icon: LucideIcons.droplets,
                    color: Colors.blueAccent,
                  ),
                  AgriMetricCard(
                    title: 'NPK Composition',
                    value: 'N: 64, P: 42, K: 55',
                    subtitle: 'Nitrogen levels elevated',
                    icon: LucideIcons.leaf,
                    color: Color(0xFF10B981),
                  ),
                  AgriMetricCard(
                    title: 'Regional Maize Price',
                    value: 'KES 3,800 / Bag',
                    subtitle: '▲ 4% fluctuation this week',
                    icon: LucideIcons.trendingUp,
                    color: Color(0xFFF59E0B),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Multi-Column Section: Diagnostic Upload Zone & Recent Advisories
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Component: AI Crop Disease Scanner
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Plant Pathology Diagnostics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload a snapshot of crop foliage to scan for fungal spots, rust, or pest infestation profiles instantly.',
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      
                      // Live Dynamic Interactive Selector Canvas Area
                      InkWell(
                        onTap: _selectedImage == null ? _handleImageSelection : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: 240,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B0F19),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedImage == null ? const Color(0xFF334155) : const Color(0xFF10B981).withOpacity(0.5), 
                              style: BorderStyle.solid,
                              width: 1.5
                            ),
                          ),
                          child: _selectedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.imagePlus, color: const Color(0xFF10B981).withOpacity(0.8), size: 40),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Select or Drop Crop Image Here',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Supports PNG, JPG (Max 10MB)',
                                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: [
                                    // Live image byte container wrapper
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        _selectedImage!.path,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        // Error handling recovery block if context layer breaks
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Text('Error rendering preview asset framework', style: TextStyle(color: Colors.grey[400])),
                                          );
                                        },
                                      ),
                                    ),
                                    // Remove/Erase Image Floating Overlay Trigger Ribbon Component
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Material(
                                        color: Colors.black.withOpacity(0.75),
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedImage = null;
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(20),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(LucideIcons.x, size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Right Component: Live Agronomic Feeds
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Field Advisories',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const AdvisoryItem(
                        tag: 'FAW Risk',
                        color: Colors.redAccent,
                        message: 'Fall Armyworm alerts reported in neighboring clusters. Inspect lower canopy whorls.',
                      ),
                      Divider(color: Colors.grey[800], height: 24),
                      const AdvisoryItem(
                        tag: 'Irrigation Strategy',
                        color: Colors.blueAccent,
                        message: 'Evapotranspiration forecast predicts high solar exposure. Shift irrigation cycles to 04:00 EAT.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable Metric Widget for Kilimo Telemetry Cards
class AgriMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AgriMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Widget for Feed Alerts
class AdvisoryItem extends StatelessWidget {
  final String tag;
  final Color color;
  final String message;

  const AdvisoryItem({
    super.key,
    required this.tag,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, height: 1.4),
        ),
      ],
    );
  }
}