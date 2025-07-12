import 'package:flutter/material.dart';
import 'package:mindmate/core/app_colors.dart';

Future<void> showDailyMoodDialog(BuildContext context) async {
  final moods = [
    'Feliz',
    'Tranquilo',
    'Estresado',
    'Triste',
    'Ansioso',
    'Motivado',
  ];

  String? selectedMood;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Cómo te sientes hoy?',
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
      content: DropdownButtonFormField<String>(
        dropdownColor: AppColors.white,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        decoration: const InputDecoration(
          labelText: 'Selecciona tu estado de ánimo',
          labelStyle: TextStyle(color: AppColors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
          ),
        ),
        items: moods
            .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
            .toList(),
        onChanged: (value) => selectedMood = value,
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedMood != null) {
              // Guarda estato de ánimo en Firestore o app
              Navigator.of(ctx).pop();
            }
          },
          child: const Text(
            'Aceptar',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ],
    ),
  );
}
