import 'package:flutter/material.dart';
import '../../models/latlng.dart';

class Amenity {
  final String id;
  final String name;
  final AmenityType type;
  final LatLng location;
  final String description;
  final bool isOpen;
  final String? hours;
  final List<String> features; // e.g., ["Handicap Accessible", "Water Available"]

  Amenity({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.description,
    required this.isOpen,
    this.hours,
    required this.features,
  });
}

enum AmenityType {
  parking,
  restroom,
  waterFountain,
  picnicArea,
  visitorCenter,
  emergencyPhone,
  firstAid;

  String get displayName {
    switch (this) {
      case AmenityType.parking:
        return 'Parking';
      case AmenityType.restroom:
        return 'Restroom';
      case AmenityType.waterFountain:
        return 'Water Fountain';
      case AmenityType.picnicArea:
        return 'Picnic Area';
      case AmenityType.visitorCenter:
        return 'Visitor Center';
      case AmenityType.emergencyPhone:
        return 'Emergency Phone';
      case AmenityType.firstAid:
        return 'First Aid';
    }
  }

  IconData get icon {
    switch (this) {
      case AmenityType.parking:
        return Icons.local_parking;
      case AmenityType.restroom:
        return Icons.wc;
      case AmenityType.waterFountain:
        return Icons.water_drop;
      case AmenityType.picnicArea:
        return Icons.restaurant;
      case AmenityType.visitorCenter:
        return Icons.info;
      case AmenityType.emergencyPhone:
        return Icons.emergency;
      case AmenityType.firstAid:
        return Icons.medical_services;
    }
  }

  Color get color {
    switch (this) {
      case AmenityType.parking:
        return Colors.blue;
      case AmenityType.restroom:
        return Colors.green;
      case AmenityType.waterFountain:
        return Colors.cyan;
      case AmenityType.picnicArea:
        return Colors.orange;
      case AmenityType.visitorCenter:
        return Colors.purple;
      case AmenityType.emergencyPhone:
        return Colors.red;
      case AmenityType.firstAid:
        return Colors.red;
    }
  }
} 