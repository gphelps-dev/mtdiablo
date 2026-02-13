import 'package:flutter/material.dart';
import 'features/maps/interactive_map_screen.dart';
import 'features/practical_tools/practical_tools_screen.dart';
import 'features/safety/safety_screen.dart';
import 'features/safety/cyclists_screen.dart';
import 'features/weather/weather_screen.dart';
import 'features/park_info/park_info_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mt Diablo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.grey[700]!,
          surface: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Two tiles per row
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
                  children: [
                    _buildTile(context, 'Safety', Icons.shield, Colors.red, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SafetyScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Weather & Air Quality', Icons.wb_sunny, Colors.amber, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeatherScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Mt Diablo Cyclists', Icons.directions_bike, Colors.orange, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CyclistsScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Trails & Map', Icons.explore, Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InteractiveMapScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Practical Tools', Icons.construction, Colors.green, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PracticalToolsScreen(),
                        ),
                      );
                    }),
                    _buildTile(context, 'Park Info', Icons.info_outline, Colors.purple, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParkInfoScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.85),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
