
import 'package:habit_tracker/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:habit_tracker/features/habits/domain/entities/habit.dart';
import 'package:habit_tracker/features/habits/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {

  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl({required this.localDataSource});

  @override
  Future<void> deleteHabit(String habitId) async {
    await localDataSource.deleteHabit(habitId);
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    final List<HabitModel> habitModels = await localDataSource.getAllHabits();

    final List<Habit> habits = habitModels.map((model) => model.toEntity()).toList();

    return habits;
  }

  @override
  Future<Habit?> getHabitById(String habitId) async {
    final habitModel = await localDataSource.getHabitById(habitId);
    return habitModel?.toEntity();
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    final habitModel = HabitModel.fromEntity(habit);

    await localDataSource.saveHabit(habitModel);
  }
}