import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SheriaScreen extends StatelessWidget {
  const SheriaScreen({super.key});

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
                    'Sheria Legal Hub',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Automated regulatory compliance & legal document processing templates.',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.scale, color: Colors.blueAccent, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'Regional Compliance Engine',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Core Workspace Layout Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Component: Document Draft Templates
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                            'AI Document Generation Templates',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select a template format to generate customized, legally binding agreements tailored to local frameworks.',
                            style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                              return GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.2,
                                children: const [
                                  TemplateCard(
                                    title: 'Commercial Lease Agreement',
                                    description: 'Standard urban business premises leasing contracts.',
                                    icon: LucideIcons.fileText,
                                  ),
                                  TemplateCard(
                                    title: 'Agricultural Land Lease',
                                    description: 'Custom clauses detailing seasonal sharecropping rules.',
                                    icon: LucideIcons.scroll,
                                  ),
                                  TemplateCard(
                                    title: 'Non-Disclosure Agreement',
                                    description: 'Protect regional startup property asset disclosures.',
                                    icon: LucideIcons.shieldCheck,
                                  ),
                                  TemplateCard(
                                    title: 'Employment Contract',
                                    description: 'Compliant with localized statutory labor codes.',
                                    icon: LucideIcons.users,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Right Component: Regulatory Framework Verification
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
                        'Compliance Checklist',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Essential operational checks for businesses.',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      const ComplianceStepItem(
                        title: 'Data Protection Officer (DPO)',
                        status: 'Compliant',
                        color: Color(0xFF10B981),
                      ),
                      Divider(color: Colors.grey[800], height: 24),
                      const ComplianceStepItem(
                        title: 'Annual Statutory Filings',
                        status: 'Pending Audit',
                        color: Color(0xFFF59E0B),
                      ),
                      Divider(color: Colors.grey[800], height: 24),
                      const ComplianceStepItem(
                        title: 'Local Council Trade License',
                        status: 'Active',
                        color: Color(0xFF10B981),
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

// Inner Widget for Template Options
class TemplateCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const TemplateCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F19),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Text('Draft Document', style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.w600)),
              SizedBox(width: 4),
              Icon(LucideIcons.arrowRight, size: 12, color: Colors.blueAccent),
            ],
          ),
        ],
      ),
    );
  }
}

// Inner Widget for Checklist Items
class ComplianceStepItem extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const ComplianceStepItem({
    super.key,
    required this.title,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}