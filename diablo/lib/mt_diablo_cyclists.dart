import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MtDiabloCyclistsPage extends StatelessWidget {
  const MtDiabloCyclistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mt. Diablo Cyclists'),
        backgroundColor: Colors.blueGrey[700], // Dark blue-grey
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'WE DID IT!! YOU DID IT! CONGRATULATIONS!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Over 400 people and organizations Donated: '
                        '\$753,922.28 for 22 New Bike Turnouts. THANK YOU!!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'There are NOW 67 Bike Turnouts in California. ALL of those 67 Bike Turnouts are on Mount Diablo.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'That’s Right, Bike Turnouts ONLY exist on Mount Diablo. '
                        'No other State – or Park in the Nation has Bike Turnouts!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: const Text(
                'Visit the Mt. Diablo Cyclists Website',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.link, color: Colors.blueGrey),
              onTap: () async {
                final url = Uri.parse('https://mountdiablocyclists.org/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
