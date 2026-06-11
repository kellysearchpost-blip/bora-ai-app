import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dashboard_screen.dart';

class HomeMainContent extends StatelessWidget {
  const HomeMainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Habari, Welcome to Bora AI', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text('Empowering African innovation through localized intelligence.', style: TextStyle(color: Colors.grey[400])),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: const Icon(LucideIcons.zap, size: 16),
                label: const Text('Upgrade Plan'),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Platform Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
                children: const [
                  MetricCard(title: 'AI Queries Used', value: '342 / 1,000', icon: LucideIcons.activity, color: Color(0xFF10B981)),
                  MetricCard(title: 'Agri-Reports Generated', value: '18 Saved', icon: LucideIcons.wheat, color: Color(0xFFF59E0B)),
                  MetricCard(title: 'Legal Consultations', value: '5 Documents', icon: LucideIcons.scale, color: Colors.blueAccent),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          Text('Specialized AI Engines', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              ModuleCard(
                title: 'Bora Chat',
                description: 'Multi-lingual AI chatbot supporting Swahili, Yoruba, Zulu, and more.',
                icon: LucideIcons.messageSquare,
                badge: 'General AI',
                onTap: () {
                  final state = context.findAncestorStateOfType<DashboardScreenState>();
                  state?.changePage(1);
                },
              ),
              ModuleCard(
                title: 'Kilimo AI Advisor',
                description: 'Soil diagnostics, crop disease analysis, and real-time market data insights.',
                icon: LucideIcons.wheat,
                badge: 'Agribusiness',
                onTap: () {
                  final state = context.findAncestorStateOfType<DashboardScreenState>();
                  state?.changePage(2);
                },
              ),
              ModuleCard(
                title: 'Sheria Legal Assistant',
                description: 'Locally relevant legal documentation processing and regional regulatory compliance guidance.',
                icon: LucideIcons.scale,
                badge: 'Legal Tech',
                onTap: () {
                  final state = context.findAncestorStateOfType<DashboardScreenState>();
                  state?.changePage(3);
                },
              ),
              ModuleCard(
                title: 'Biashara Writer',
                description: 'Generate hyper-localized marketing copy, business proposals, and grant pitches.',
                icon: LucideIcons.briefcase,
                badge: 'Content/Biz',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String badge;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: const Color(0xFF10B981), size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF374151)),
                  ),
                  child: Text(badge, style: const TextStyle(fontSize: 11, color: Color(0xFF10B981))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Launch Engine', style: TextStyle(color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(width: 4),
                const Icon(LucideIcons.arrowRight, size: 14, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}