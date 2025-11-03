import 'package:flutter/material.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:habit_tracker/features/habits/domain/repositories/habit_repository.dart';
import 'package:uuid/uuid.dart';

enum HabitState { initial, loading, loaded, error }

class HabitProvider extends ChangeNotifier {
  final HabitRepository _habitRepository;

  HabitProvider({required HabitRepository habitRepository})
      : _habitRepository = habitRepository;

  var _state = HabitState.initial;
  HabitState get state => _state;

  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;


  Future<void> loadHabits() async {
    _state = HabitState.loading;
    notifyListeners();

    try {
      _habits = await _habitRepository.getAllHabits();
      _state = HabitState.loaded;
    } catch (e) {
      _state = HabitState.error;
    }
    notifyListeners();
  }

  void changeSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);

    final bool isCompleted = habit.isCompletedOn(_selectedDate);

    List<DateTime> updatedDates;

    if (isCompleted) {
      updatedDates = habit.completedDates
          .where((date) => !(date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day))
          .toList();
    } else {
      updatedDates = [...habit.completedDates, _selectedDate];
    }

    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      icon: habit.icon,
      color: habit.color,
      completedDates: updatedDates,
    );

    await _habitRepository.saveHabit(updatedHabit);

    await loadHabits();
  }

  Future<void> addNewHabit(String name) async {
    if (name.isEmpty) return;

    const uuid = Uuid();

    final newHabit = Habit(
      id: uuid.v4(),
      name: name,
      icon: Icons.star,
      color: Colors.blue,
      completedDates: [],
    );

    await _habitRepository.saveHabit(newHabit);
    await loadHabits();
  }
}

