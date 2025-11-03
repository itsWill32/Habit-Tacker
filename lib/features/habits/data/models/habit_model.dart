import 'package:hive/hive.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:flutter/material.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;



  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final List<DateTime> completedDates;

  HabitModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    required this.completedDates,
  });


  factory HabitModel.fromEntity(Habit habit) {
    return HabitModel(
      id: habit.id,
      name: habit.name,
      iconCodePoint: habit.icon.codePoint,
      colorValue: habit.color.value,
      completedDates: habit.completedDates,
    );
  }


  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      icon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
      color: Color(colorValue),
      completedDates: completedDates,
    );
  }
}
