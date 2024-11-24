import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mt. Diablo Weather'),
        backgroundColor: Colors.blueGrey[700], // Dark blue-grey
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildLink('Summit Weather', 'https://mesowest.utah.edu'),
          _buildLink('Junction Weather', 'https://www.wunderground.com'),
          _buildLink('Rock City Weather', 'https://www.wunderground.com'),
          _buildLink('Mitchell Canyon Weather', 'https://www.wunderground.com'),
          _buildLink('Summit AQI', 'https://map.purpleair.com'),
          _buildLink('Junction AQI', 'https://map.purpleair.com'),
          _buildLink('Mitchell Canyon AQI', 'https://map.purpleair.com'),
        ],
      ),
    );
  }

  Widget _buildLink(String title, String url) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(Icons.link, color: Colors.blueGrey[700]),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
