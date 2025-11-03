import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/features/habits/data/models/habit_model.dart';

const kHabitBoxName = 'habits';

class HabitLocalDataSource {
  final Box<HabitModel> _habitBox = Hive.box<HabitModel>(kHabitBoxName);

  Future<List<HabitModel>> getAllHabits() async {
    return _habitBox.values.toList();
  }

  Future<void> saveHabit(HabitModel habit) async {
    await _habitBox.put(habit.id, habit);
  }

  Future<void> deleteHabit(String habitId) async {
    await _habitBox.delete(habitId);
  }

  Future<HabitModel?> getHabitById(String habitId) async {
    return _habitBox.get(habitId);
  }
}
