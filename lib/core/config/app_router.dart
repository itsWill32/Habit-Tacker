import 'package:go_router/go_router.dart';
import 'package:habit_tracker/features/habits/presentation/screens/home_screen.dart';
import 'package:habit_tracker/features/habits/presentation/screens/habit_details_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String habitDetails = 'habit-details';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,

  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),

      routes: [
        GoRoute(
          name: AppRoutes.habitDetails,
          path: '${AppRoutes.habitDetails}/:id',
          builder: (context, state) {
            final String habitId = state.pathParameters['id']!;

            return HabitDetailsScreen(habitId: habitId);
          },
        ),
      ],
    ),
  ],
);