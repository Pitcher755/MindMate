import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';

class RegisterGoalsView extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const RegisterGoalsView({super.key, required this.onBack});

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
  bool isLoading = false;

  Future<void> _finalizeRegistration() async {
    if (selectedGoals.isEmpty || selectedMood == null) {
      showSnackBar(
        context,
        'Selecciona el menos un objetivo y un estado de ánimo.',
      );
      return;
    }

    // Guarda los datos temporalmente
    ref
        .read(authControllerProvider.notifier)
        .updatePartialUserData(goals: selectedGoals, mood: selectedMood);

        print('🧠 Mood enviado al controlador: $selectedMood'); // DEPURACION

    setState(() => isLoading = true);

    // Obtiene el uid y el email del usuario actual
    final user = ref.read(authControllerProvider);
    if (user == null) {
      showSnackBar(context, 'No se encontró el usuario.');
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .submitRegistration(user.uid, user.email ?? '');
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      showSnackBar(context, 'Error al registrar usuario: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          color: AppColors.accentYellow.withValues(alpha: 0.7),
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
                      label: Text(
                        goal,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
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
                  dropdownColor: AppColors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16.0),
                  items: moods
                      .map(
                        (mood) => DropdownMenuItem<String>(
                          value: mood,
                          child: Text(
                            mood,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        )
                      )
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedMood = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '¿Cómo te sientes hoy?',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        child: const Text(
                          'Atrás',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _finalizeRegistration,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.white,
                              )
                            : const Text(
                                'Finalizar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
