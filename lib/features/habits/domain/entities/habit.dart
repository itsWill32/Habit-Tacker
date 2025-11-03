
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.completedDates,
  });


  bool isCompletedOn(DateTime date) {
    return completedDates.any(
          (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }
}
