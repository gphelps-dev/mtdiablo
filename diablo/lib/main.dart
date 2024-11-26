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
      debugShowCheckedModeBanner: false, // Removes the debug banner
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
                  Colors.black.withOpacity(0.2),
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
                child: Align(
                  alignment: Alignment.bottomCenter, // Move grid lower on the screen
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50), // Adjust distance from bottom
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      shrinkWrap: true, // Prevents full scrollable height
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
                          'Cyclists',
                          Icons.directions_bike,
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MtDiabloCyclistsPage()),
                          ),
                        ),
                        _buildTile(
                          context,
                          'Weather',
                          Icons.cloud,
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WeatherPage()),
                          ),
                        ),
                      ],
                    ),
                  ),
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
        color: (Colors.blueGrey[50] ?? Colors.blueGrey).withOpacity(0.9),
        elevation: 3, // Reduced shadow for a simpler look
        margin: const EdgeInsets.all(8), // Reduced margin between cards
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 25, color: Colors.blueGrey[700]), // Smaller icon size
              const SizedBox(height: 5), // Reduced spacing
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14, // Smaller font size
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
