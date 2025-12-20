import 'package:flutter/material.dart';
import '../../models/latlng.dart';

class Trail {
  final String id;
  final String name;
  final String description;
  final double distance; // in miles
  final double elevationGain; // in feet
  final TrailDifficulty difficulty;
  final List<LatLng> coordinates;
  final List<String> features; // e.g., ["Water", "Shade", "Views"]
  final String trailhead;
  final bool isLoop;
  final String estimatedTime; // e.g., "2-3 hours"

  Trail({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.elevationGain,
    required this.difficulty,
    required this.coordinates,
    required this.features,
    required this.trailhead,
    required this.isLoop,
    required this.estimatedTime,
  });
}

enum TrailDifficulty {
  easy,
  moderate,
  difficult,
  expert;

  String get displayName {
    switch (this) {
      case TrailDifficulty.easy:
        return 'Easy';
      case TrailDifficulty.moderate:
        return 'Moderate';
      case TrailDifficulty.difficult:
        return 'Difficult';
      case TrailDifficulty.expert:
        return 'Expert';
    }
  }

  Color get color {
    switch (this) {
      case TrailDifficulty.easy:
        return Colors.green;
      case TrailDifficulty.moderate:
        return Colors.yellow;
      case TrailDifficulty.difficult:
        return Colors.orange;
      case TrailDifficulty.expert:
        return Colors.red;
    }
  }
} 