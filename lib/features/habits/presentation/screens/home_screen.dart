import 'package:flutter/material.dart';
import 'package:habit_tracker/features/habits/presentation/providers/habit_provider.dart';
import 'package:habit_tracker/features/habits/presentation/widgets/habit_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().loadHabits();
    });
  }

  void _selectDate(BuildContext context) async {
    final provider = context.read<HabitProvider>();
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (newDate != null) {
      provider.changeSelectedDate(newDate);
    }
  }

  void _showAddHabitDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir Nuevo Hábito'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Nombre del hábito"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                context.read<HabitProvider>().addNewHabit(textController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    final provider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Hábitos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddHabitDialog(context),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(provider.selectedDate),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _buildBody(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HabitProvider provider) {
    switch (provider.state) {
      case HabitState.loading:
        return const Center(child: CircularProgressIndicator());

      case HabitState.error:
        return const Center(child: Text('Error al cargar los hábitos.'));

      case HabitState.loaded:
        if (provider.habits.isEmpty) {
          return const Center(
            child: Text(
              'No hay hábitos. ¡Añade uno con el botón +!',
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.habits.length,
          itemBuilder: (context, index) {
            final habit = provider.habits[index];
            return HabitTile(habit: habit);
          },
        );

      case HabitState.initial:
      default:
        return const Center(child: Text('Iniciando...'));
    }
  }

  String _formatDate(DateTime date) {
    const monthNames = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
    return "${monthNames[date.month - 1]} ${date.day}, ${date.year}";
  }
}
