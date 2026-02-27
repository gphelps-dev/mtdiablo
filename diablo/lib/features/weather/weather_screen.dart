import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Air Quality'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildWeatherStationsSection(),
          const SizedBox(height: 24),
          _buildAirQualitySection(),
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
            Icon(Icons.wb_sunny, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Weather & Air Quality',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Real-time conditions across Mount Diablo State Park',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStationsSection() {
    const webcamUrl = 'https://www.meteoblue.com/en/weather/webcams/mount-diablo-state-park_united-states_5375163';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.thermostat, color: Colors.blue, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Weather Stations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildWeatherStationTile(
              'Summit Weather',
              'Real-time conditions at the summit',
              Icons.landscape,
              Colors.orange,
              'https://mesowest.utah.edu/cgi-bin/droman/meso_base.cgi?stn=SJS02',
              'https://ops.alertcalifornia.org/cam-console/2156',
            ),
            const SizedBox(height: 12),
            _buildWeatherStationTile(
              'Junction Weather',
              'Conditions at Junction Ranger Station',
              Icons.signpost,
              Colors.green,
              'https://www.wunderground.com/dashboard/pws/KCACLAYT79',
              webcamUrl,
            ),
            const SizedBox(height: 12),
            _buildWeatherStationTile(
              'Rock City Weather',
              'Weather at Rock City area',
              Icons.nature,
              Colors.brown,
              'https://www.wunderground.com/dashboard/pws/KCAALAMO68',
              webcamUrl,
            ),
            const SizedBox(height: 12),
            _buildWeatherStationTile(
              'Mitchell Canyon Weather',
              'Conditions at Mitchell Canyon trailhead',
              Icons.hiking,
              Colors.teal,
              'https://www.wunderground.com/dashboard/pws/KCACLAYT73?cm_ven=localwx_pwsdash',
              webcamUrl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualitySection() {
    const webcamUrl = 'https://www.meteoblue.com/en/weather/webcams/mount-diablo-state-park_united-states_5375163';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.air, color: Colors.purple, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Air Quality Monitors',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAirQualityTile(
              'Summit Air Quality',
              'Real-time AQI at the summit',
              Icons.landscape,
              Colors.purple,
              'https://map.purpleair.com/?opt=1/mAQI/a10/cC0&key=WZRAE0D746KP9G67&select=91079#11/37.8817/-121.9146',
              'https://ops.alertcalifornia.org/cam-console/2156',
            ),
            const SizedBox(height: 12),
            _buildAirQualityTile(
              'Junction Air Quality',
              'AQI at Junction Ranger Station',
              Icons.signpost,
              Colors.indigo,
              'https://map.purpleair.com/air-quality-standards-us-epa-aqi?key=VHFIF4VHDHIZBZW0&select=141110&opt=%2F1%2Flp%2Fa10%2Fp604800%2FcC0#11/37.8668/-121.9325',
              webcamUrl,
            ),
            const SizedBox(height: 12),
            _buildAirQualityTile(
              'Mitchell Canyon Air Quality',
              'AQI near Mitchell Canyon',
              Icons.hiking,
              Colors.deepPurple,
              'https://map.purpleair.com/?opt=1/mAQI/a10/cC0#11/37.8816/-121.9142',
              webcamUrl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStationTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String url,
    String webcamUrl,
  ) {
    return Container(
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.videocam, color: color),
              onPressed: () => _launchURL(webcamUrl),
              tooltip: 'View Webcam',
            ),
            Icon(Icons.open_in_new, color: color),
          ],
        ),
        onTap: () => _launchURL(url),
      ),
    );
  }

  Widget _buildAirQualityTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String url,
    String webcamUrl,
  ) {
    return Container(
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.videocam, color: color),
              onPressed: () => _launchURL(webcamUrl),
              tooltip: 'View Webcam',
            ),
            Icon(Icons.open_in_new, color: color),
          ],
        ),
        onTap: () => _launchURL(url),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
