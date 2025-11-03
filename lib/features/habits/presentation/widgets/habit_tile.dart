import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/core/config/app_router.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:habit_tracker/features/habits/presentation/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    final isCompleted = habit.isCompletedOn(provider.selectedDate);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),

      child: InkWell(
        onTap: () {

          context.goNamed(
            AppRoutes.habitDetails,
            pathParameters: {'id': habit.id},
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: CircleAvatar(
            backgroundColor: habit.color.withOpacity(0.2),
            child: Icon(
              habit.icon,
              color: habit.color,
              size: 30,
            ),
          ),

          title: Text(
            habit.name,
            style: TextStyle(
              fontSize: 18,
              decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),

          trailing: Checkbox(
            value: isCompleted,
            activeColor: habit.color,
            onChanged: (bool? value) {
              context.read<HabitProvider>().toggleHabitCompletion(habit.id);
            },
          ),
        ),
      ),
    );
  }
}