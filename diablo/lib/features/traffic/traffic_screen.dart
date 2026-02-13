import 'package:flutter/material.dart';

class TrafficScreen extends StatelessWidget {
  const TrafficScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mt Diablo Traffic'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTrafficConditionsSection(),
          const SizedBox(height: 24),
          _buildParkingStatusSection(),
          const SizedBox(height: 24),
          _buildVisitorTipsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.traffic, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Human Traffic Monitor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Real-time visitor and traffic conditions at Mount Diablo',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficConditionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: Colors.blue, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Traffic Conditions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTrafficLocation(
              'Summit Road',
              'Main route to the summit',
              Icons.landscape,
              Colors.orange,
              TrafficLevel.moderate,
            ),
            const SizedBox(height: 12),
            _buildTrafficLocation(
              'North Gate Entrance',
              'Mitchell Canyon entrance',
              Icons.door_front_door,
              Colors.green,
              TrafficLevel.light,
            ),
            const SizedBox(height: 12),
            _buildTrafficLocation(
              'South Gate Entrance',
              'Main park entrance',
              Icons.door_front_door,
              Colors.teal,
              TrafficLevel.moderate,
            ),
            const SizedBox(height: 12),
            _buildTrafficLocation(
              'Junction',
              'Junction Ranger Station area',
              Icons.signpost,
              Colors.blue,
              TrafficLevel.light,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_parking, color: Colors.purple, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Parking Availability',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildParkingStatus(
              'Summit Parking',
              'Limited spaces available',
              ParkingStatus.limited,
            ),
            const SizedBox(height: 12),
            _buildParkingStatus(
              'Mitchell Canyon',
              'Spaces available',
              ParkingStatus.available,
            ),
            const SizedBox(height: 12),
            _buildParkingStatus(
              'Rock City',
              'Spaces available',
              ParkingStatus.available,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Peak hours: Weekends 9AM-2PM. Arrive early or consider visiting during weekdays.',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitorTipsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Visitor Tips',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Best Times to Visit',
              'Weekdays before 9AM or after 3PM for fewer crowds',
              Icons.access_time,
            ),
            _buildTip(
              'Cyclist-Motorist Sharing',
              'Use designated bike turnouts to allow vehicles to pass safely',
              Icons.pedal_bike,
            ),
            _buildTip(
              'Peak Season',
              'Spring (March-May) is busiest due to wildflowers and mild weather',
              Icons.calendar_month,
            ),
            _buildTip(
              'Alternative Routes',
              'Consider Mitchell Canyon entrance for a quieter experience',
              Icons.alt_route,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficLocation(
    String name,
    String description,
    IconData icon,
    Color color,
    TrafficLevel level,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _buildTrafficIndicator(level),
        ],
      ),
    );
  }

  Widget _buildTrafficIndicator(TrafficLevel level) {
    Color indicatorColor;
    String label;
    IconData iconData;

    switch (level) {
      case TrafficLevel.light:
        indicatorColor = Colors.green;
        label = 'Light';
        iconData = Icons.check_circle;
        break;
      case TrafficLevel.moderate:
        indicatorColor = Colors.orange;
        label = 'Moderate';
        iconData = Icons.warning;
        break;
      case TrafficLevel.heavy:
        indicatorColor = Colors.red;
        label = 'Heavy';
        iconData = Icons.error;
        break;
    }

    return Column(
      children: [
        Icon(iconData, color: indicatorColor, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: indicatorColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildParkingStatus(
    String name,
    String status,
    ParkingStatus parkingStatus,
  ) {
    Color statusColor;
    IconData statusIcon;

    switch (parkingStatus) {
      case ParkingStatus.available:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case ParkingStatus.limited:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case ParkingStatus.full:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTip(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum TrafficLevel {
  light,
  moderate,
  heavy,
}

enum ParkingStatus {
  available,
  limited,
  full,
}
