import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkInfoScreen extends StatelessWidget {
  const ParkInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Park Information'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            isScrollable: true,
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Conservation'),
              Tab(text: 'Events'),
              Tab(text: 'Resources'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAboutTab(),
            _buildConservationTab(),
            _buildEventsTab(),
            _buildResourcesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'About Mount Diablo',
          'Mount Diablo is a 3,849-foot peak in Contra Costa County, California. It is the centerpiece of Mount Diablo State Park and provides spectacular views of the San Francisco Bay Area.',
          Icons.landscape,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Park Hours',
          'Sunrise to Sunset (varies by season)\nVisitor Center: 10:00 AM - 4:00 PM\nSummit Building: 10:00 AM - 4:00 PM',
          Icons.access_time,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Parking & Fees',
          'Day Use Fee: \$10 per vehicle\nAnnual Pass: \$195\nSenior Pass: \$10 (62+)\nDisabled Veterans: Free',
          Icons.local_parking,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Contact Information',
          'Mt. Diablo State Park\n96 Mitchell Canyon Road\nClayton, CA 94517\nPhone: (925) 837-2525',
          Icons.contact_phone,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildConservationTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Save Mount Diablo',
          'Since 1971, Save Mount Diablo has preserved over 120,000 acres of wild lands around Mount Diablo - an area bigger than Point Reyes National Seashore.',
          Icons.eco,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Conservation Mission',
          'Our mission is to forever preserve the remaining natural lands on and around Mount Diablo, and to protect Mount Diablo\'s connection to its sustaining Diablo Range.',
          Icons.nature,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Protected Lands',
          'Over 120,000 acres of protected lands including:\n• Mt. Diablo State Park\n• Regional parks\n• Open space preserves\n• Wildlife corridors',
          Icons.park,
          Colors.green,
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Get Involved',
          'Support conservation efforts through volunteering, donations, or advocacy.',
          Icons.volunteer_activism,
          Colors.green,
          () => _launchURL('https://savemountdiablo.org/how-to-help/'),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEventCard(
          'Mangini Ranch Meditation Hike',
          'August 2nd, 2025\n7:00 AM - 10:00 AM',
          'Join Save Mount Diablo on a meditation journey through Mangini Ranch!',
          Icons.self_improvement,
          Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          'Hit the Trails – Mountain Biking',
          'August 15th, 2025\n9:00 AM - 12:00 PM',
          'Come explore the beautiful trails from Smith Canyon into Mount Diablo\'s beautiful Curry Canyon via mountain bike.',
          Icons.directions_bike,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          'Plein Air Painting Hike',
          'August 23rd, 2025\n10:00 AM - 1:00 PM',
          'Join Save Mount Diablo for a beautiful evening of plein air painting on Curry Canyon Ranch.',
          Icons.brush,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'View All Events',
          'Check the full calendar of upcoming hikes, outings, and conservation events.',
          Icons.calendar_today,
          Colors.blue,
          () => _launchURL('https://savemountdiablo.org/events/'),
        ),
      ],
    );
  }

  Widget _buildResourcesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionCard(
          'Trail Map',
          'Get our free regional trail map including trails and parks on and around Mount Diablo.',
          Icons.map,
          Colors.green,
          () => _launchURL('https://savemountdiablo.org/experience/trail-map/'),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Field Guides',
          'Download guides for plants, hikes, and audible tours of Mount Diablo.',
          Icons.book,
          Colors.blue,
          () => _launchURL('https://savemountdiablo.org/experience/field-guides/'),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Discover Diablo Hikes',
          'Join guided hikes and educational outings throughout the Diablo Range.',
          Icons.hiking,
          Colors.orange,
          () => _launchURL('https://savemountdiablo.org/experience/discover-diablo-hikes-outings/'),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Volunteer Opportunities',
          'Help with stewardship, events, leading hikes, and office work.',
          Icons.volunteer_activism,
          Colors.purple,
          () => _launchURL('https://savemountdiablo.org/how-to-help/volunteer/'),
        ),
        const SizedBox(height: 16),
        _buildActionCard(
          'Donate',
          'Support conservation efforts with your donation.',
          Icons.favorite,
          Colors.red,
          () => _launchURL('https://savemountdiablo.org/how-to-help/donate-now/'),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String date, String description, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String description, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(Icons.open_in_new, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
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