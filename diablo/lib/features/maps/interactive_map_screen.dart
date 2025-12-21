import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../trails/trail_model.dart';
import '../trails/trail_data.dart';
import '../practical_tools/amenity_model.dart';
import '../practical_tools/amenity_data.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  bool _showTrails = true;
  bool _showAmenities = true;
  String _searchQuery = '';

  List<Trail> get _filteredTrails {
    var trails = TrailData.trails;
    if (_searchQuery.isNotEmpty) {
      trails = trails.where((trail) =>
          trail.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          trail.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          trail.features.any((feature) => feature.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }
    return trails;
  }

  List<Amenity> get _filteredAmenities {
    var amenities = AmenityData.amenities;
    if (_searchQuery.isNotEmpty) {
      amenities = amenities.where((amenity) =>
          amenity.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          amenity.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    return amenities;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trails & Map'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Trails'),
              Tab(text: 'Amenities'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTrailsTab(),
                  _buildAmenitiesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search trails and amenities...',
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

  Widget _buildTrailsTab() {
    final trails = _filteredTrails;
    
    if (trails.isEmpty) {
      return const Center(
        child: Text(
          'No trails found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trails.length,
      itemBuilder: (context, index) {
        final trail = trails[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: trail.difficulty.color,
              child: Text(
                trail.difficulty.displayName[0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              trail.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trail.description),
                const SizedBox(height: 8),
                                 Wrap(
                   spacing: 8,
                   runSpacing: 4,
                   children: [
                     Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.straighten, size: 16, color: Colors.grey[600]),
                         const SizedBox(width: 4),
                         Text('${trail.distance} miles'),
                       ],
                     ),
                     Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.trending_up, size: 16, color: Colors.grey[600]),
                         const SizedBox(width: 4),
                         Text('${trail.elevationGain} ft'),
                       ],
                     ),
                     Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                         const SizedBox(width: 4),
                         Text(trail.estimatedTime),
                       ],
                     ),
                   ],
                 ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: trail.features.map((feature) => Chip(
                    label: Text(
                      feature,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.grey[200],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ],
            ),
            onTap: () => _showTrailDetails(trail),
          ),
        );
      },
    );
  }

  Widget _buildAmenitiesTab() {
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
            onTap: () => _showAmenityDetails(amenity),
          ),
        );
      },
    );
  }

  void _showTrailDetails(Trail trail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: trail.difficulty.color,
              child: Text(
                trail.difficulty.displayName[0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(trail.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trail.description),
            const SizedBox(height: 16),
            _buildDetailRow('Distance', '${trail.distance} miles'),
            _buildDetailRow('Elevation Gain', '${trail.elevationGain} feet'),
            _buildDetailRow('Difficulty', trail.difficulty.displayName),
            _buildDetailRow('Estimated Time', trail.estimatedTime),
            _buildDetailRow('Trailhead', trail.trailhead),
            _buildDetailRow('Loop Trail', trail.isLoop ? 'Yes' : 'No'),
            const SizedBox(height: 8),
            const Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: trail.features.map((feature) => Chip(
                label: Text(feature),
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openDirections(trail);
            },
            child: const Text('Get Directions'),
          ),
        ],
      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _openDirections(dynamic item) {
    // Show coordinates instead of opening Apple Maps
    String coordinates;
    String locationName;
    
    if (item is Trail) {
      if (item.coordinates.isNotEmpty) {
        final firstCoord = item.coordinates.first;
        coordinates = '${firstCoord.latitude}, ${firstCoord.longitude}';
        locationName = item.name;
      } else {
        coordinates = 'N/A';
        locationName = item.trailhead;
      }
    } else if (item is Amenity) {
      coordinates = '${item.location.latitude}, ${item.location.longitude}';
      locationName = item.name;
    } else {
      return;
    }
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location: $locationName'),
          content: SelectableText('Coordinates: $coordinates'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
} 