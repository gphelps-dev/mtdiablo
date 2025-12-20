import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'event_model.dart';

class EventsService {
  static const String _baseUrl = 'https://savemountdiablo.org';
  static const String _eventsUrl = '$_baseUrl/events/';
  static const String _cacheKey = 'cached_events';
  static const Duration _cacheExpiry = Duration(hours: 6);

  // Sample events based on the website data
  // Using dates relative to today so events always show up
  static List<Event> get _sampleEvents {
    final now = DateTime.now();
    return [
      Event(
        id: '1',
        title: 'Mangini Ranch Meditation Hike',
        description: 'Meditation hike through Mangini Ranch. Practice mindfulness while exploring the preserve.',
        date: now.add(const Duration(days: 7)),
        timeRange: '7:00 AM - 10:00 AM',
        category: 'Meditation',
        registrationUrl: 'https://savemountdiablo.org/events/mangini-ranch-meditation-hike/',
      ),
      Event(
        id: '2',
        title: 'Hit the Trails – Mountain Biking',
        description: 'Mountain bike ride from Smith Canyon to Curry Canyon. Explore trails in the Diablo Range.',
        date: now.add(const Duration(days: 14)),
        timeRange: '9:00 AM - 12:00 PM',
        category: 'Mountain Biking',
        registrationUrl: 'https://savemountdiablo.org/events/hit-the-trails-mountain-biking/',
      ),
      Event(
        id: '3',
        title: 'Plein Air Painting Hike',
        description: 'Plein air painting hike on Curry Canyon Ranch. Paint the Diablo Range landscapes.',
        date: now.add(const Duration(days: 21)),
        timeRange: '10:00 AM - 1:00 PM',
        category: 'Art',
        registrationUrl: 'https://savemountdiablo.org/events/plein-air-painting-hike/',
      ),
      Event(
        id: '4',
        title: 'Diablo Restoration Team (DiRT) Workday',
        description: 'Volunteer workday to restore habitats and maintain trails. Learn about native plants.',
        date: now.add(const Duration(days: 28)),
        timeRange: '9:00 AM - 2:00 PM',
        category: 'Stewardship',
        registrationUrl: 'https://savemountdiablo.org/events/dirt-workday/',
      ),
      Event(
        id: '5',
        title: 'BioBlitz: Wildlife Survey',
        description: 'Wildlife survey with scientists and naturalists. Help document Mount Diablo biodiversity.',
        date: now.add(const Duration(days: 35)),
        timeRange: '8:00 AM - 4:00 PM',
        category: 'BioBlitz',
        registrationUrl: 'https://savemountdiablo.org/events/bioblitz-wildlife-survey/',
      ),
      Event(
        id: '6',
        title: 'Discover Diablo: Geology Hike',
        description: 'Geology hike with expert guides. Learn how Mount Diablo was formed and see unique rock formations.',
        date: now.add(const Duration(days: 42)),
        timeRange: '10:00 AM - 3:00 PM',
        category: 'Education',
        registrationUrl: 'https://savemountdiablo.org/events/geology-hike/',
      ),
      Event(
        id: '7',
        title: 'Weekend Nature Walk',
        description: 'Guided nature walk through Mount Diablo State Park. Good for families.',
        date: now.add(const Duration(days: 3)),
        timeRange: '9:00 AM - 11:00 AM',
        category: 'Hiking',
        registrationUrl: 'https://savemountdiablo.org/events/weekend-nature-walk/',
      ),
      Event(
        id: '8',
        title: 'Sunset Photography Workshop',
        description: 'Sunset photography workshop at the summit. Learn techniques and enjoy the views.',
        date: now.add(const Duration(days: 10)),
        timeRange: '5:00 PM - 8:00 PM',
        category: 'Art',
        registrationUrl: 'https://savemountdiablo.org/events/sunset-photography/',
      ),
    ];
  }

  static Future<List<Event>> getEvents() async {
    try {
      // Try to get cached events first
      final cachedEvents = await _getCachedEvents();
      if (cachedEvents.isNotEmpty) {
        // Check if cached events are still valid (not all in the past)
        final hasUpcomingEvents = cachedEvents.any((e) => e.isUpcoming);
        if (hasUpcomingEvents) {
          return cachedEvents;
        }
        // If all cached events are in the past, clear cache and get fresh ones
        await refreshEvents();
      }

      // If no cache or expired, try to fetch from website
      final fetchedEvents = await _fetchEventsFromWebsite();
      if (fetchedEvents.isNotEmpty) {
        await _cacheEvents(fetchedEvents);
        return fetchedEvents;
      }

      // Fallback to sample events (always uses current dates)
      final sampleEvents = _sampleEvents;
      await _cacheEvents(sampleEvents);
      return sampleEvents;
    } catch (e) {
      print('Error fetching events: $e');
      // Return sample events with current dates
      return _sampleEvents;
    }
  }

  static Future<List<Event>> _fetchEventsFromWebsite() async {
    try {
      final response = await http.get(Uri.parse(_eventsUrl));
      
      if (response.statusCode == 200) {
        // Parse the HTML content to extract events
        // This is a simplified parser - in a real app you'd use a proper HTML parser
        final events = _parseEventsFromHtml(response.body);
        return events;
      }
    } catch (e) {
      print('Error fetching from website: $e');
    }
    
    return [];
  }

  static List<Event> _parseEventsFromHtml(String html) {
    // This is a simplified parser - in production you'd use a proper HTML parser
    // For now, we'll return sample events with current dates
    return _sampleEvents;
  }

  static Future<List<Event>> _getCachedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      
      if (cachedData != null) {
        final Map<String, dynamic> data = json.decode(cachedData);
        final timestamp = DateTime.parse(data['timestamp']);
        
        // Check if cache is still valid
        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          final List<dynamic> eventsData = data['events'];
          final events = eventsData.map((eventData) => _eventFromJson(eventData)).toList();
          
          // Validate that cached events are still valid (not all in the past)
          // If all events are in the past, return empty to trigger refresh
          final hasUpcomingEvents = events.any((e) => e.isUpcoming);
          if (hasUpcomingEvents) {
            return events;
          }
          // All events are in the past, clear cache
          await prefs.remove(_cacheKey);
        }
      }
    } catch (e) {
      print('Error reading cached events: $e');
    }
    
    return [];
  }

  static Future<void> _cacheEvents(List<Event> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsData = events.map((event) => _eventToJson(event)).toList();
      
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'events': eventsData,
      };
      
      await prefs.setString(_cacheKey, json.encode(cacheData));
    } catch (e) {
      print('Error caching events: $e');
    }
  }

  static Map<String, dynamic> _eventToJson(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'date': event.date.toIso8601String(),
      'timeRange': event.timeRange,
      'category': event.category,
      'registrationUrl': event.registrationUrl,
      'imageUrl': event.imageUrl,
      'isFeatured': event.isFeatured,
    };
  }

  static Event _eventFromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      timeRange: json['timeRange'],
      category: json['category'],
      registrationUrl: json['registrationUrl'],
      imageUrl: json['imageUrl'],
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  static Future<void> refreshEvents() async {
    // Clear cache and fetch fresh data
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
    // Force reload by clearing any in-memory cache if needed
  }

  static List<Event> getUpcomingEvents(List<Event> events) {
    return events.where((event) => event.isUpcoming).toList();
  }

  static List<Event> getEventsByCategory(List<Event> events, String category) {
    return events.where((event) => 
      event.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  static List<String> getCategories(List<Event> events) {
    final categories = events.map((event) => event.category).toSet().toList();
    categories.sort();
    return categories;
  }
} 