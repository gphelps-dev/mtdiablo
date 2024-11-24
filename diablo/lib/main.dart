import 'package:flutter/material.dart';
import 'weather.dart';
import 'park_staff.dart';
import 'park_info.dart';
import 'mt_diablo_cyclists.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mt. Diablo App',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Semi-transparent background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/background_icon_optimized.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), // Correct usage
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Content on top of the background
          Column(
            children: [
              AppBar(
                title: const Text('Mt. Diablo App'),
                backgroundColor: Colors.blueGrey[700],
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(10),
                  children: [
                    _buildTile(
                      context,
                      'Park Info',
                      Icons.info,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ParkInfoPage()),
                      ),
                    ),
                    _buildTile(
                      context,
                      'Park Staff',
                      Icons.people,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ParkStaffPage()),
                      ),
                    ),
                    _buildTile(
                      context,
                      'Mt. Diablo Cyclists',
                      Icons.directions_bike,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MtDiabloCyclistsPage()),
                      ),
                    ),
                    _buildTile(
                      context,
                      'Mt. Diablo Weather',
                      Icons.cloud,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WeatherPage()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: (Colors.blueGrey[50] ?? Colors.blueGrey).withOpacity(0.9), // Fixed nullability
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueGrey[700]),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
