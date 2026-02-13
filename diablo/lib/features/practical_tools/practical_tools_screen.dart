import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'amenity_model.dart';
import 'amenity_data.dart';

class PracticalToolsScreen extends StatefulWidget {
  const PracticalToolsScreen({super.key});

  @override
  State<PracticalToolsScreen> createState() => _PracticalToolsScreenState();
}

class _PracticalToolsScreenState extends State<PracticalToolsScreen> {
  AmenityType? _selectedFilter;
  String _searchQuery = '';

  List<Amenity> get _filteredAmenities {
    var amenities = AmenityData.amenities;
    
    if (_selectedFilter != null) {
      amenities = amenities.where((a) => a.type == _selectedFilter).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      amenities = amenities.where((a) =>
          a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return amenities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practical Tools'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _buildAmenityList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search amenities...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedFilter == null,
            onSelected: (selected) {
              setState(() {
                _selectedFilter = null;
              });
            },
          ),
          const SizedBox(width: 8),
          ...AmenityType.values.map((type) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(type.displayName),
              selected: _selectedFilter == type,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = selected ? type : null;
                });
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAmenityList() {
    final amenities = _filteredAmenities;
    
    if (amenities.isEmpty) {
      return const Center(
        child: Text(
          'No amenities found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final amenity = amenities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: amenity.type.color,
              child: Icon(
                amenity.type.icon,
                color: Colors.white,
              ),
            ),
            title: Text(amenity.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amenity.description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      amenity.isOpen ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: amenity.isOpen ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      amenity.isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: amenity.isOpen ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    if (amenity.hours != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• ${amenity.hours}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
                if (amenity.features.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: amenity.features.map((feature) => Chip(
                      label: Text(
                        feature,
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.grey[200],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'directions':
                    _openDirections(amenity);
                    break;
                  case 'call':
                    _callAmenity(amenity);
                    break;
                  case 'share':
                    _shareAmenity(amenity);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'directions',
                  child: Row(
                    children: [
                      Icon(Icons.directions),
                      SizedBox(width: 8),
                      Text('Get Directions'),
                    ],
                  ),
                ),
                if (amenity.type == AmenityType.emergencyPhone)
                  const PopupMenuItem(
                    value: 'call',
                    child: Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 8),
                        Text('Call Emergency'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              _showAmenityDetails(amenity);
            },
          ),
        );
      },
    );
  }

  void _openDirections(Amenity amenity) {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${amenity.location.latitude},${amenity.location.longitude}';
    _launchURL(url);
  }

  void _callAmenity(Amenity amenity) {
    if (amenity.type == AmenityType.emergencyPhone) {
      _launchURL('tel:911');
    }
  }

  void _shareAmenity(Amenity amenity) {
    final text = '${amenity.name} at Mt. Diablo State Park\n${amenity.description}';
    // In a real app, you'd use a proper sharing plugin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing: $text')),
    );
  }

  void _showAmenityDetails(Amenity amenity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: amenity.type.color,
              child: Icon(amenity.type.icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(amenity.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(amenity.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  amenity.isOpen ? Icons.check_circle : Icons.cancel,
                  color: amenity.isOpen ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  amenity.isOpen ? 'Open' : 'Closed',
                  style: TextStyle(
                    color: amenity.isOpen ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (amenity.hours != null) ...[
              const SizedBox(height: 8),
              Text('Hours: ${amenity.hours}'),
            ],
            if (amenity.features.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: amenity.features.map((feature) => Chip(
                  label: Text(feature),
                  backgroundColor: Colors.grey[200],
                )).toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _openDirections(amenity);
            },
            icon: const Icon(Icons.directions),
            label: const Text('Directions'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
} 