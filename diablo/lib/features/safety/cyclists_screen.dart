import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/latlng.dart';
import '../traffic/traffic_screen.dart';

class CyclistsScreen extends StatelessWidget {
  const CyclistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mt Diablo Cyclists'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTrafficTile(context),
          const SizedBox(height: 24),
          _buildBikeTurnoutsSection(),
          const SizedBox(height: 24),
          _buildEasementSection(),
          const SizedBox(height: 24),
          _buildBikeRepairStationsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: InkWell(
        onTap: () => _launchURL('https://mountdiablocyclists.org/'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.pedal_bike, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Mt Diablo Cyclists',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.open_in_new, size: 20, color: Colors.grey[600]),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Supporting safe cycling on Mount Diablo',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to visit website',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficTile(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TrafficScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.blue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 28,
                  child: const Icon(Icons.traffic, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mt Diablo Traffic Monitor',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View real-time visitor traffic and parking conditions',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBikeTurnoutsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pedal_bike, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                const Text(
                  '67 Bike Turnouts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Mount Diablo features 67 strategically placed bike turnouts along its roads, designed to enhance safety for both cyclists and motorists.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'Purpose',
              'These turnouts provide safe spaces for cyclists to pull over and allow vehicles to pass, reducing conflicts on narrow mountain roads.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'Location',
              'Turnouts are distributed along the main roads leading to the summit, including North Gate Road, South Gate Road, and Summit Road.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'Usage',
              'Cyclists are encouraged to use these turnouts when vehicles approach from behind, promoting courteous sharing of the road.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEasementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.celebration, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Historic Easement Reopened!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700], size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'The Historic Easement to Mount Diablo State Park Reopened!',
                          style: TextStyle(
                            color: Colors.green[900],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Special Thanks to Dave Hammond!',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell ALL your friends! Share this post with Everyone!',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchURL('https://bikedanville.org/court-orders-reopening-of.../'),
              icon: const Icon(Icons.article),
              label: const Text('Read More Information'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              'What is an Easement?',
              'An easement is a legal right to use another person\'s land for a specific purpose. In this case, it protects cycling access and infrastructure on Mount Diablo.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'Benefits',
              'The easement helps maintain and improve cycling infrastructure, including the 67 bike turnouts, ensuring safe passage for cyclists for years to come.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              'Conservation',
              'This easement also supports conservation efforts, balancing recreational use with the protection of Mount Diablo\'s natural resources.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeRepairStationsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.build_circle, color: Colors.blue, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Bike Repair Stations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Mount Diablo features 8 bike repair stations installed through Eagle Scout projects, providing essential tools and supplies for cyclists in need.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            _buildRepairStationInfo(
              'Mountain Bike Repair Boxes',
              'Installed in June 2018 by Justin, Troop #36 (Danville)',
              'Macedo Ranch, Mitchell Canyon, and Live Oak Campground',
              const LatLng(37.8816, -121.9142), // Mitchell Canyon approximate
              'Special Thanks to Valley Spokesmen for paying for the pumps, tools and tubes!',
            ),
            const SizedBox(height: 16),
            _buildRepairStationInfo(
              'Road Bike Repair Boxes',
              'Installed in February 2017 by Volney Spalding, Troop #36 (Danville)',
              'Summit and South Gate Kiosk',
              const LatLng(37.8950, -121.9027), // Summit approximate
              null,
            ),
            const SizedBox(height: 16),
            _buildRepairStationInfo(
              'Road Bike Repair Box',
              'Installed in August 2016 by Chris Wong, Troop #815 (Danville)',
              'Junction Ranger Station',
              const LatLng(37.8865, -121.9082), // Junction approximate
              'Special Thanks to Dave Dalton (6Fifteen Cyclery) for donating the tools/floor pump.',
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[800], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please Help: Donate tubes, tires, etc. NO FOOD! The Raccoons will trash the boxes!',
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _openMapsDirections(),
              icon: const Icon(Icons.map),
              label: const Text('View Maps & Directions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepairStationInfo(
    String title,
    String projectInfo,
    String locations,
    LatLng coordinates,
    String? specialThanks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    projectInfo,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Locations: $locations',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                  if (specialThanks != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      specialThanks,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMapsDirections() async {
    // Open Google Maps with Mount Diablo State Park as the destination
    const url = 'https://www.google.com/maps/dir/?api=1&destination=Mount+Diablo+State+Park,+California';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
