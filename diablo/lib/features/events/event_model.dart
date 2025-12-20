import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String timeRange;
  final String category;
  final String? registrationUrl;
  final String? imageUrl;
  final bool isFeatured;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.timeRange,
    required this.category,
    this.registrationUrl,
    this.imageUrl,
    this.isFeatured = false,
  });

  String get formattedDate {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}${_getDaySuffix(date.day)}';
  }

  String get formattedTime {
    return timeRange;
  }

  String get daysUntil {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    if (difference < 0) return 'Past';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return '$difference days';
  }

  bool get isUpcoming {
    return date.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'hike':
      case 'hiking':
        return Icons.hiking;
      case 'bike':
      case 'biking':
      case 'mountain biking':
        return Icons.directions_bike;
      case 'meditation':
        return Icons.self_improvement;
      case 'painting':
      case 'art':
        return Icons.brush;
      case 'stewardship':
      case 'volunteer':
        return Icons.volunteer_activism;
      case 'education':
        return Icons.school;
      case 'bioblitz':
        return Icons.nature;
      default:
        return Icons.event;
    }
  }

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'hike':
      case 'hiking':
        return Colors.green;
      case 'bike':
      case 'biking':
      case 'mountain biking':
        return Colors.orange;
      case 'meditation':
        return Colors.purple;
      case 'painting':
      case 'art':
        return Colors.blue;
      case 'stewardship':
      case 'volunteer':
        return Colors.red;
      case 'education':
        return Colors.teal;
      case 'bioblitz':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }
} 