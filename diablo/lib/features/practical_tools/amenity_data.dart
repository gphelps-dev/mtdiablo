import 'dart:math';
import '../../models/latlng.dart';
import 'amenity_model.dart';

class AmenityData {
  static List<Amenity> get amenities => [
    // Parking Areas
    Amenity(
      id: 'mitchell-canyon-parking',
      name: 'Mitchell Canyon Parking',
      type: AmenityType.parking,
      location: const LatLng(37.8816, -121.9142),
      description: 'Main parking area for Mitchell Canyon trails. \$10 day use fee.',
      isOpen: true,
      hours: 'Sunrise to Sunset',
      features: ['Pay Station', 'Trailhead Access', 'Restrooms Nearby'],
    ),
    Amenity(
      id: 'summit-parking',
      name: 'Summit Parking',
      type: AmenityType.parking,
      location: const LatLng(37.8950, -121.9027),
      description: 'Parking at the summit with spectacular views.',
      isOpen: true,
      hours: 'Sunrise to Sunset',
      features: ['Views', 'Visitor Center Nearby', 'Restrooms Nearby'],
    ),
    Amenity(
      id: 'juniper-campground-parking',
      name: 'Juniper Campground Parking',
      type: AmenityType.parking,
      location: const LatLng(37.8865, -121.9082),
      description: 'Parking for Juniper Campground and nearby trails.',
      isOpen: true,
      hours: '24/7',
      features: ['Campground Access', 'Trailhead Access'],
    ),

    // Restrooms
    Amenity(
      id: 'mitchell-canyon-restroom',
      name: 'Mitchell Canyon Restroom',
      type: AmenityType.restroom,
      location: const LatLng(37.8818, -121.9140),
      description: 'Restrooms near the main trailhead.',
      isOpen: true,
      hours: 'Sunrise to Sunset',
      features: ['Handicap Accessible', 'Running Water'],
    ),
    Amenity(
      id: 'summit-restroom',
      name: 'Summit Restroom',
      type: AmenityType.restroom,
      location: const LatLng(37.8952, -121.9025),
      description: 'Restrooms at the summit.',
      isOpen: true,
      hours: 'Sunrise to Sunset',
      features: ['Handicap Accessible', 'Running Water'],
    ),

    // Water Fountains
    Amenity(
      id: 'mitchell-canyon-water',
      name: 'Mitchell Canyon Water Fountain',
      type: AmenityType.waterFountain,
      location: const LatLng(37.8817, -121.9141),
      description: 'Water fountain at the trailhead.',
      isOpen: true,
      hours: '24/7',
      features: ['Potable Water', 'Refill Station'],
    ),
    Amenity(
      id: 'summit-water',
      name: 'Summit Water Fountain',
      type: AmenityType.waterFountain,
      location: const LatLng(37.8951, -121.9026),
      description: 'Water fountain at the summit.',
      isOpen: true,
      hours: '24/7',
      features: ['Potable Water', 'Refill Station'],
    ),

    // Picnic Areas
    Amenity(
      id: 'mitchell-canyon-picnic',
      name: 'Mitchell Canyon Picnic Area',
      type: AmenityType.picnicArea,
      location: const LatLng(37.8819, -121.9139),
      description: 'Picnic area with tables and grills.',
      isOpen: true,
      hours: 'Sunrise to Sunset',
      features: ['Tables', 'Grills', 'Shade', 'Water Nearby'],
    ),
    Amenity(
      id: 'summit-picnic',
      name: 'Summit Picnic Area',
      type: AmenityType.picnicArea,
      location: const LatLng(37.8953, -121.9024),
      description: 'Picnic area with Bay Area views.',
      isOpen: true,
      hours: 'Sunrise to Sunset',
      features: ['Tables', 'Views', 'Water Nearby'],
    ),

    // Visitor Center
    Amenity(
      id: 'summit-visitor-center',
      name: 'Summit Visitor Center',
      type: AmenityType.visitorCenter,
      location: const LatLng(37.8954, -121.9023),
      description: 'Visitor center with exhibits and maps.',
      isOpen: true,
      hours: '10:00 AM - 4:00 PM',
      features: ['Exhibits', 'Maps', 'Information', 'Gift Shop'],
    ),

    // Emergency Phones
    Amenity(
      id: 'summit-emergency-phone',
      name: 'Summit Emergency Phone',
      type: AmenityType.emergencyPhone,
      location: const LatLng(37.8955, -121.9022),
      description: 'Emergency phone for rangers and 911.',
      isOpen: true,
      hours: '24/7',
      features: ['Direct to Rangers', 'Emergency Services'],
    ),
    Amenity(
      id: 'mitchell-canyon-emergency-phone',
      name: 'Mitchell Canyon Emergency Phone',
      type: AmenityType.emergencyPhone,
      location: const LatLng(37.8820, -121.9138),
      description: 'Emergency phone at the main trailhead.',
      isOpen: true,
      hours: '24/7',
      features: ['Direct to Rangers', 'Emergency Services'],
    ),

    // First Aid
    Amenity(
      id: 'summit-first-aid',
      name: 'Summit First Aid Station',
      type: AmenityType.firstAid,
      location: const LatLng(37.8956, -121.9021),
      description: 'First aid station with medical supplies.',
      isOpen: true,
      hours: '24/7',
      features: ['First Aid Kit', 'Emergency Equipment', 'Ranger Access'],
    ),
  ];

  static Amenity? getAmenityById(String id) {
    try {
      return amenities.firstWhere((amenity) => amenity.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Amenity> getAmenitiesByType(AmenityType type) {
    return amenities.where((amenity) => amenity.type == type).toList();
  }

  static List<Amenity> getAmenitiesNearLocation(LatLng location, double radiusInMeters) {
    // Simple distance calculation (in a real app, you'd use a proper geolocation library)
    return amenities.where((amenity) {
      final distance = _calculateDistance(location, amenity.location);
      return distance <= radiusInMeters;
    }).toList();
  }

  static double _calculateDistance(LatLng point1, LatLng point2) {
    // Simple distance calculation (approximate)
    const double earthRadius = 6371000; // meters
    final double lat1 = point1.latitude * (3.14159 / 180);
    final double lat2 = point2.latitude * (3.14159 / 180);
    final double deltaLat = (point2.latitude - point1.latitude) * (3.14159 / 180);
    final double deltaLon = (point2.longitude - point1.longitude) * (3.14159 / 180);

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final double c = 2 * atan(sqrt(a) / sqrt(1 - a));

    return earthRadius * c;
  }
} 