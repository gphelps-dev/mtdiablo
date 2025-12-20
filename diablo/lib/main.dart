import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'features/maps/interactive_map_screen.dart';
import 'features/practical_tools/practical_tools_screen.dart';
import 'features/emergency/emergency_contacts.dart';
import 'features/park_info/park_info_screen.dart';
import 'features/events/events_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mt Diablo App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey[700]!,
          background: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mount Diablo Contra Costa County',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Logo section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Image.asset(
                'assets/icons/app_icon.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // If image fails to load, show a placeholder icon
                  return Icon(
                    Icons.landscape,
                    size: 100,
                    color: Colors.grey[400],
                  );
                },
              ),
            ),
            // Navigation tiles
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2, // Two tiles per row
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildTile(context, 'Trails & Map', Icons.map, Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InteractiveMapScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Practical Tools', Icons.build, Colors.green, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PracticalToolsScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Emergency', Icons.phone, Colors.red, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmergencyContactsScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Park Info', Icons.info, Colors.purple, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParkInfoScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Events', Icons.event, Colors.purple, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EventsScreen()),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
