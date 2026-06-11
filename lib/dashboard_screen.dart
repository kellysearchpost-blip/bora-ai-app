import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import 'landing_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const ChatScreen(),
    const EducationScreen(),
    const HealthScreen(),
    const AgricultureScreen(),
    const BusinessScreen(),
    const ResearchScreen(),
  ];

  final List<String> _titles = [
    'Chat',
    'Education',
    'Health',
    'Agriculture',
    'Business',
    'Research',
  ];

  final List<IconData> _icons = [
    LucideIcons.messageSquare,
    LucideIcons.graduationCap,
    LucideIcons.heart,
    LucideIcons.wheat,
    LucideIcons.briefcase,
    LucideIcons.atom,
  ];

  void changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer after navigation
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    
    // Use drawer for mobile, permanent sidebar for desktop
    if (isDesktop) {
      return _buildDesktopLayout();
    } else {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF0B0F19),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111827),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.menu, color: Colors.white, size: 24),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: const Text(
            'BORA AI',
            style: TextStyle(
              color: Color(0xFF10B981),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        drawer: _buildDrawer(),
        body: _screens[_selectedIndex],
      );
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFF0B0F19),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF111827),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "B",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "BORA AI",
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: 0),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _titles.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                final isComingSoon = index != 0;
                return ListTile(
                  leading: Icon(
                    _icons[index],
                    color: isSelected ? const Color(0xFF10B981) : Colors.grey[400],
                    size: 22,
                  ),
                  title: Row(
                    children: [
                      Text(
                        _titles[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF10B981) : Colors.grey[300],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Soon',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                  selected: isSelected,
                  selectedTileColor: const Color(0xFF10B981).withOpacity(0.1),
                  onTap: () {
                    if (index == 0) {
                      changePage(index);
                    } else {
                      Navigator.pop(context);
                      _showComingSoonDialog(context, _titles[index]);
                    }
                  },
                );
              },
            ),
          ),
          const Divider(color: Colors.grey, height: 0),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey[400], size: 22),
            title: const Text("Logout", style: TextStyle(color: Colors.grey, fontSize: 15)),
            onTap: _logout,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border(right: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "B",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "BORA AI",
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: 0),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _titles.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                final isComingSoon = index != 0;
                return ListTile(
                  leading: Icon(
                    _icons[index],
                    color: isSelected ? const Color(0xFF10B981) : Colors.grey[400],
                    size: 22,
                  ),
                  title: Row(
                    children: [
                      Text(
                        _titles[index],
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF10B981) : Colors.grey[300],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Soon',
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                  selected: isSelected,
                  selectedTileColor: const Color(0xFF10B981).withOpacity(0.1),
                  onTap: () {
                    if (index == 0) {
                      changePage(index);
                    } else {
                      _showComingSoonDialog(context, _titles[index]);
                    }
                  },
                );
              },
            ),
          ),
          const Divider(color: Colors.grey, height: 0),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey[400], size: 22),
            title: const Text("Logout", style: TextStyle(color: Colors.grey, fontSize: 15)),
            onTap: _logout,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String moduleName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: Row(
          children: [
            Icon(LucideIcons.rocket, color: const Color(0xFF10B981), size: 24),
            const SizedBox(width: 12),
            Text('Coming Soon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'The $moduleName module is currently in development. We\'re working hard to bring you amazing features! Stay tuned.',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: Color(0xFF10B981))),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF10B981).withOpacity(0.3)),
        ),
      ),
    );
  }
}

// Coming Soon Screens (simplified)
class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, size: 80, color: Color(0xFF10B981)),
          ),
          const SizedBox(height: 24),
          const Text("Education Module", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("Coming Soon", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF10B981)),
          ),
          const SizedBox(height: 24),
          const Text("Health Module", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("Coming Soon", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

class AgricultureScreen extends StatelessWidget {
  const AgricultureScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.agriculture, size: 80, color: Color(0xFFF59E0B)),
          ),
          const SizedBox(height: 24),
          const Text("Agriculture Module", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("Coming Soon", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business, size: 80, color: Color(0xFF8B5CF6)),
          ),
          const SizedBox(height: 24),
          const Text("Business Module", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("Coming Soon", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}

class ResearchScreen extends StatelessWidget {
  const ResearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF06B6D4).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.science, size: 80, color: Color(0xFF06B6D4)),
          ),
          const SizedBox(height: 24),
          const Text("Research Module", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          const Text("Coming Soon", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}