import 'package:flutter/material.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:habit_tracker/features/habits/presentation/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitDetailsScreen extends StatelessWidget {
  final String habitId;

  const HabitDetailsScreen({super.key, required this.habitId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();


    Habit? habit;
    try {
      habit = provider.habits.firstWhere((h) => h.id == habitId);
    } catch (e) {
      habit = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(habit?.name ?? 'Detalles del Hábito'),
        backgroundColor: habit?.color.withAlpha(50),
      ),
      body: habit == null
          ? const Center(child: Text('Hábito no encontrado.'))
          : _buildDetailsBody(context, habit),
    );
  }

  Widget _buildDetailsBody(BuildContext context, Habit habit) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: habit.color.withOpacity(0.2),
                child: Icon(habit.icon, color: habit.color, size: 40),
              ),
              const SizedBox(width: 16),
              Text(
                habit.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const Divider(height: 40),

          Text(
            'Estadísticas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: const Text('Completado (Total)'),
              trailing: Text(
                '${habit.completedDates.length} días',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}