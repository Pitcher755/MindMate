import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';

class RegisterGoalsView extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RegisterGoalsView({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<RegisterGoalsView> createState() => _RegisterGoalsViewState();
}

class _RegisterGoalsViewState extends ConsumerState<RegisterGoalsView> {
  // Objetivos a alcanzar
  final List<String> allGoals = [
    'Reducir ansiedad',
    'Mejorar el sueño',
    'Aumentar la concentración',
    'Desarrollar hábitos positivos',
    'Mejorar el estado de ánimo',
    'Gestionar el estrés',
  ];

  // Estados de ánimo
  final List<String> moods = [
    'Feliz',
    'Tranquilo',
    'Estresado',
    'Triste',
    'Ansioso',
    'Motivado',
  ];

  // Selección de objetivo
  List<String> selectedGoals = [];
  // Selección de estado de ánimo
  String? selectedMood;

  void _continue() {
    if (selectedGoals.isEmpty || selectedMood == null) {
      showSnackBar(
        context,
        'Selecciona al menos un objetivo y un estado de ánimo.',
      );
      return;
    }

    // Guarda los datos temporalmente
    ref
        .read(authControllerProvider.notifier)
        .updatePartialUserData(goals: selectedGoals, mood: selectedMood);

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: AppColors.accentGreen.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Qué quieres conseguir',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: allGoals.map((goal) {
                  final isSelected = selectedGoals.contains(goal);
                  return FilterChip(
                    label: Text(goal),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGoals.add(goal);
                        } else {
                          selectedGoals.remove(goal);
                        }
                      });
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: AppColors.white,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: selectedMood,
                items: moods
                    .map(
                      (mood) => DropdownMenuItem<String>(
                        value: mood,
                        child: Text(mood),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMood = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: '¿Cómo te sientes hoy?',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _continue,
                      child: const Text('Finalizar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
