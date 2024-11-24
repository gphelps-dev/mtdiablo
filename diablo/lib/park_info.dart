import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkInfoPage extends StatelessWidget {
  const ParkInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Park Info'),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildInfoCard(
            'Contact Number',
            '(925) 837-6129',
            isPhone: true,
          ),
          _buildInfoCard(
            'Park Accessibility Information',
            'View the Park Accessibility Information',
            link: 'https://www.parks.ca.gov/?page_id=517',
          ),
          _buildInfoCard(
            'Park Hours',
            'Gates open 8:00am and close at sunset. Visitors should plan to be in their vehicles by sunset and headed out to avoid being locked in.',
          ),
          _buildInfoCard(
            'Buses',
            'Pilot car recommended',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title,
      String detail, {
        String? link,
        bool isPhone = false,
      }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          detail,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: link != null || isPhone
            ? const Icon(Icons.arrow_forward, color: Colors.blueGrey)
            : null,
        onTap: () async {
          if (link != null) {
            final uri = Uri.parse(link);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $link';
            }
          } else if (isPhone) {
            final uri = Uri(
              scheme: 'tel',
              path: detail,
            );
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              throw 'Could not call $detail';
            }
          }
        },
      ),
    );
  }
}
