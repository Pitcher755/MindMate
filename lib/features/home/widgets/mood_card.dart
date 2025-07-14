import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/home/provider/mood_quote_provider.dart';

class MoodCard extends ConsumerWidget {
  final String mood;
  final String userName;

  MoodCard({required this.mood, required this.userName});

  // Lista de iconos por estado de ánimo, con posibilidad de cambios
  final Map<String, List<IconData>> moodIcons = {
    'feliz': [Icons.emoji_emotions, Icons.wb_sunny, Icons.cake],
    'estresado': [Icons.spa, Icons.self_improvement, Icons.nights_stay],
    'triste': [Icons.cloud, Icons.favorite, Icons.handshake],
    'ansioso': [Icons.bubble_chart, Icons.hotel, Icons.ac_unit],
    'motivado': [Icons.rocket_launch, Icons.bolt, Icons.thumb_up],
    'tranquilo': [Icons.water_drop, Icons.weekend, Icons.nature_people], 
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodQuotesAsync = ref.watch(moodQuoteByMoodProvider(mood));

    return moodQuotesAsync.when(
      data: (quotes) {
        final quote = quotes.isNotEmpty
        ? quotes[Random().nextInt(quotes.length)]
        : null;

      final iconList = moodIcons[mood.toLowerCase()] ?? [Icons.psychology];
      final icon = iconList[Random().nextInt(iconList.length)];

      return Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.accentBlue.withValues(alpha: 0.3),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 48, color: AppColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  quote != null
                  ? quote.text.replaceAll('\$name', userName)
                  : 'Hoy es un buen día para empezar con calma, $userName.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      );
      },
      loading:() => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const Text('No se pudo cargar el mensaje.'),
    );
  }
}