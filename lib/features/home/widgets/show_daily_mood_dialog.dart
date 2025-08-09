import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';
import 'package:mindmate/features/home/provider/mood_quote_provider.dart';

Future<void> showDailyMoodDialog(BuildContext context, WidgetRef ref) async {
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
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Cómo te sientes hoy?',
        style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
      content: DropdownButtonFormField<String>(
        dropdownColor: AppColors.primary,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
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
          onPressed: () async {
            if (selectedMood == null) return;

            try {
              // Guardar el nuevo mood en Firestore
              await ref
              .read(authControllerProvider.notifier)
              .updateDailyMood(selectedMood!);

              // Forzar recarga del documento user para que la UI obtenga el mood nuevo
              ref.invalidate(userDataProvider);

              // Obtener el nombre actual del usuario
              final user = await ref.read(userDataProvider.future);
              final userName = user.name;

              // Refrescar el provider de la frase motivadora
              final key = (mood: selectedMood!.toLowerCase(), userName: userName);

              // Invalidar family con el record correcto
              ref.invalidate(moodQuoteServiceProvider(key));

              // Pre-cargar la nueva frase motivadora antes de cerrar el diálogo
              try {
                await ref.read(
                  moodQuoteServiceProvider(key).future,
                );
              } catch (e) {
                // ignorar: si falla la carga no se rompe el flujo principal
              }

              // Cerrar el diálogo
              if (ctx.mounted) Navigator.of(ctx).pop();
              
            } catch (e) {
              if(ctx.mounted) {
                showSnackBar(ctx, 'Error al guardar estado: $e');
              }
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
