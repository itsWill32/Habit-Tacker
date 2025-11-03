import 'package:flutter/material.dart';
import 'package:habit_tracker/core/config/app_router.dart';
import 'package:habit_tracker/features/habits/data/datasources/habit_local_datasource.dart';
import 'package:habit_tracker/features/habits/data/models/habit_model.dart';
import 'package:habit_tracker/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:habit_tracker/features/habits/domain/repositories/habit_repository.dart';
import 'package:habit_tracker/features/habits/presentation/providers/habit_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();


  Hive.registerAdapter(HabitModelAdapter());

  await Hive.openBox<HabitModel>(kHabitBoxName);


  final HabitLocalDataSource localDataSource = HabitLocalDataSource();


  final HabitRepository habitRepository = HabitRepositoryImpl(
    localDataSource: localDataSource,
  );

  runApp(
    MyApp(habitRepository: habitRepository),
  );
}

class MyApp extends StatelessWidget {
  final HabitRepository habitRepository;

  const MyApp({super.key, required this.habitRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HabitProvider(habitRepository: habitRepository),
        ),
      ],

      child: MaterialApp.router(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,

        routerConfig: appRouter,
      ),
    );
  }
}