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
          _buildLink('Summit Weather', 'https://mesowest.utah.edu/cgi-bin/droman/meso_base.cgi?stn=SJS02&unit=0&time=LOCAL&product=&year1=&month1=&day1=00&hour1=00&hours=&graph=1&past=0'),
          _buildLink('Summit Webcam', 'https://alertca.live/cam-console/2156'),
          _buildLink('Junction Weather', 'https://www.wunderground.com/dashboard/pws/KCACLAYT79'),
          _buildLink('Rock City Weather', 'https://www.wunderground.com/dashboard/pws/KCAALAMO68'),
          _buildLink('Mitchell Canyon Weather', 'https://www.wunderground.com/dashboard/pws/KCACLAYT73?cm_ven=localwx_pwsdash'),
          _buildLink('Diablo Summit AQI', 'https://map.purpleair.com/air-quality-standards-us-epa-aqi?key=WZRAE0D746KP9G67&select=91079&opt=%2F1%2Flp%2Fa10%2Fp604800%2FcC0#11/37.8817/-121.9146'),
          _buildLink('Junction Ranger Station AQI', 'https://map.purpleair.com/air-quality-standards-us-epa-aqi?key=VHFIF4VHDHIZBZW0&select=141110&opt=%2F1%2Flp%2Fa10%2Fp604800%2FcC0#11/37.8668/-121.9325'),
          _buildLink('Mitchell Canyon AQI', 'https://map.purpleair.com/air-quality-standards-us-epa-aqi?select=90205&opt=%2F1%2Flp%2Fa10%2Fp604800%2FcC0#12/37.90072/-122.003'),
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
