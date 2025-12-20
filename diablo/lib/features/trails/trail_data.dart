import '../../models/latlng.dart';
import 'trail_model.dart';

class TrailData {
  static List<Trail> get trails => [
    Trail(
      id: 'summit-trail',
      name: 'Summit Trail',
      description: 'The classic route to the summit of Mt. Diablo. Steep but rewarding with panoramic views of the Bay Area.',
      distance: 3.8,
      elevationGain: 1200,
      difficulty: TrailDifficulty.difficult,
      coordinates: [
        const LatLng(37.8816, -121.9142), // Trailhead
        const LatLng(37.8830, -121.9130),
        const LatLng(37.8845, -121.9118),
        const LatLng(37.8860, -121.9105),
        const LatLng(37.8875, -121.9092),
        const LatLng(37.8890, -121.9079),
        const LatLng(37.8905, -121.9066),
        const LatLng(37.8920, -121.9053),
        const LatLng(37.8935, -121.9040),
        const LatLng(37.8950, -121.9027), // Summit
      ],
      features: ['Views', 'Wildflowers', 'Historical Sites'],
      trailhead: 'Mitchell Canyon',
      isLoop: false,
      estimatedTime: '2-3 hours',
    ),
    Trail(
      id: 'mitchell-canyon',
      name: 'Mitchell Canyon Trail',
      description: 'A beautiful canyon trail with oak woodlands and seasonal streams. Great for families.',
      distance: 2.5,
      elevationGain: 400,
      difficulty: TrailDifficulty.moderate,
      coordinates: [
        const LatLng(37.8816, -121.9142), // Trailhead
        const LatLng(37.8820, -121.9135),
        const LatLng(37.8825, -121.9128),
        const LatLng(37.8830, -121.9121),
        const LatLng(37.8835, -121.9114),
        const LatLng(37.8840, -121.9107),
        const LatLng(37.8845, -121.9100),
        const LatLng(37.8850, -121.9093),
      ],
      features: ['Shade', 'Water', 'Wildlife'],
      trailhead: 'Mitchell Canyon',
      isLoop: true,
      estimatedTime: '1-2 hours',
    ),
    Trail(
      id: 'juniper-trail',
      name: 'Juniper Trail',
      description: 'A scenic trail through juniper woodlands with excellent views of the surrounding valleys.',
      distance: 1.8,
      elevationGain: 300,
      difficulty: TrailDifficulty.easy,
      coordinates: [
        const LatLng(37.8816, -121.9142), // Trailhead
        const LatLng(37.8825, -121.9130),
        const LatLng(37.8835, -121.9118),
        const LatLng(37.8845, -121.9106),
        const LatLng(37.8855, -121.9094),
        const LatLng(37.8865, -121.9082),
      ],
      features: ['Views', 'Wildflowers', 'Easy Walking'],
      trailhead: 'Juniper Campground',
      isLoop: true,
      estimatedTime: '45-90 minutes',
    ),
    Trail(
      id: 'rock-city',
      name: 'Rock City Trail',
      description: 'Explore fascinating sandstone formations and rock outcrops. Great for rock climbing and bouldering.',
      distance: 1.2,
      elevationGain: 200,
      difficulty: TrailDifficulty.easy,
      coordinates: [
        const LatLng(37.8816, -121.9142), // Trailhead
        const LatLng(37.8820, -121.9135),
        const LatLng(37.8825, -121.9128),
        const LatLng(37.8830, -121.9121),
        const LatLng(37.8835, -121.9114),
      ],
      features: ['Rock Formations', 'Climbing', 'Views'],
      trailhead: 'Rock City',
      isLoop: true,
      estimatedTime: '30-60 minutes',
    ),
  ];

  static Trail? getTrailById(String id) {
    try {
      return trails.firstWhere((trail) => trail.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Trail> getTrailsByDifficulty(TrailDifficulty difficulty) {
    return trails.where((trail) => trail.difficulty == difficulty).toList();
  }

  static List<Trail> searchTrails(String query) {
    final lowercaseQuery = query.toLowerCase();
    return trails.where((trail) =>
        trail.name.toLowerCase().contains(lowercaseQuery) ||
        trail.description.toLowerCase().contains(lowercaseQuery) ||
        trail.features.any((feature) => feature.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }
} 