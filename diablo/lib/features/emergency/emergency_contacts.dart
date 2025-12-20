import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLocationSection(),
          const SizedBox(height: 24),
          _buildEmergencySection(),
          const SizedBox(height: 24),
          _buildParkRangersSection(),
          const SizedBox(height: 24),
          _buildMedicalSection(),
          const SizedBox(height: 24),
          _buildSafetyTipsSection(),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Location Services',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_currentPosition != null) ...[
              _buildLocationInfo(),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    icon: _isLoadingLocation 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(_isLoadingLocation ? 'Getting Location...' : 'Get My Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentPosition != null ? _shareLocationWithContacts : null,
                    icon: const Icon(Icons.share_location),
                    label: const Text('Share Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Share your location with emergency contacts or family members in case of emergency.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Current Location:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(1)} meters',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emergency, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Emergency Services',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactTile(
              'Emergency (911)',
              'For life-threatening emergencies',
              Icons.phone,
              Colors.red,
              () => _launchURL('tel:911'),
              showLocationShare: true,
            ),
            _buildContactTile(
              'California State Parks',
              'Mt. Diablo State Park Office',
              Icons.park,
              Colors.green,
              () => _launchURL('tel:925-837-2525'),
              showLocationShare: true,
            ),
            _buildContactTile(
              'Contra Costa County Sheriff',
              'Non-emergency dispatch',
              Icons.security,
              Colors.blue,
              () => _launchURL('tel:925-646-2441'),
              showLocationShare: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkRangersSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Park Rangers & Staff',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactTile(
              'Mt. Diablo State Park',
              'Main office - 8:00 AM to 5:00 PM',
              Icons.phone,
              Colors.green,
              () => _launchURL('tel:925-837-2525'),
              showLocationShare: true,
            ),
            _buildContactTile(
              'Save Mount Diablo',
              'Conservation organization',
              Icons.phone,
              Colors.green,
              () => _launchURL('tel:925-947-3535'),
              showLocationShare: true,
            ),
            _buildContactTile(
              'East Bay Regional Parks',
              'Regional park district',
              Icons.phone,
              Colors.green,
              () => _launchURL('tel:888-327-2757'),
              showLocationShare: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Medical & First Aid',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactTile(
              'John Muir Medical Center',
              'Walnut Creek - 24/7 Emergency',
              Icons.local_hospital,
              Colors.red,
              () => _launchURL('tel:925-947-3322'),
              showLocationShare: true,
            ),
            _buildContactTile(
              'Kaiser Permanente',
              'Walnut Creek Medical Center',
              Icons.local_hospital,
              Colors.red,
              () => _launchURL('tel:925-295-4000'),
              showLocationShare: true,
            ),
            _buildContactTile(
              'Sutter Health',
              'Concord Medical Center',
              Icons.local_hospital,
              Colors.red,
              () => _launchURL('tel:925-674-2000'),
              showLocationShare: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTipsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.safety_divider, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Safety Tips',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSafetyTip(
              'Stay on marked trails',
              'Avoid getting lost by following official park trails',
              Icons.track_changes,
            ),
            _buildSafetyTip(
              'Carry water and supplies',
              'Bring plenty of water, snacks, and first aid kit',
              Icons.water_drop,
            ),
            _buildSafetyTip(
              'Check weather conditions',
              'Be aware of weather forecasts before hiking',
              Icons.cloud,
            ),
            _buildSafetyTip(
              'Tell someone your plans',
              'Let friends or family know your hiking route and return time',
              Icons.message,
            ),
            _buildSafetyTip(
              'Know your location',
              'Use GPS or trail markers to know where you are',
              Icons.location_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, {bool showLocationShare = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLocationShare && _currentPosition != null)
            IconButton(
              icon: const Icon(Icons.share_location),
              onPressed: () => _shareLocationWithContact(title),
              tooltip: 'Share location',
            ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: onTap,
            tooltip: 'Call',
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSafetyTip(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDialog();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog();
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location obtained successfully!')),
      );
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _shareLocationWithContacts() {
    if (_currentPosition == null) return;
    
    final locationText = 'My current location: '
        'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    
    _launchURL('sms:?body=$locationText');
  }

  void _shareLocationWithContact(String contactName) {
    if (_currentPosition == null) return;
    
    final locationText = 'Emergency: I am at '
        'https://maps.google.com/?q=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    
    // Try to send via SMS first, then fallback to other methods
    _launchURL('sms:?body=$locationText');
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location permission to share your location in emergencies. '
          'Please enable location access in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
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