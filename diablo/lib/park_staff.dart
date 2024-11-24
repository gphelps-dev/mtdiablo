import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkStaffPage extends StatelessWidget {
  const ParkStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Park Staff'),
        backgroundColor: Colors.blueGrey[700], // Dark blue-grey
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildContactCard(
            'MDSP General Feedback Email',
            'Feedback.MountDiablo@parks.ca.gov',
            isEmail: true,
          ),
          _buildContactCard(
            'Clint Elsholz: Superintendent',
            'clinton.elsholz@parks.ca.gov\n(916) 705-3022',
            email: 'clinton.elsholz@parks.ca.gov',
            phone: '(916) 705-3022',
          ),
          _buildContactCard(
            'Ryen Goering: Chief Ranger',
            'ryen.goering@parks.ca.gov\n(925) 890-4403',
            email: 'ryen.goering@parks.ca.gov',
            phone: '(925) 890-4403',
          ),
          _buildContactCard(
            'Summit Visitor Center',
            '(925) 837-6119',
            isPhone: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      String title,
      String detail, {
        String? email,
        String? phone,
        bool isEmail = false,
        bool isPhone = false,
      }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if (isEmail || email != null)
              InkWell(
                onTap: () async {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: isEmail ? detail : email,
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch email: $detail';
                  }
                },
                child: Text(
                  isEmail ? detail : email!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            if (isPhone || phone != null) ...[
              const SizedBox(height: 5),
              InkWell(
                onTap: () async {
                  final uri = Uri(
                    scheme: 'tel',
                    path: isPhone ? detail : phone,
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch phone: $detail';
                  }
                },
                child: Text(
                  isPhone ? detail : phone!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
