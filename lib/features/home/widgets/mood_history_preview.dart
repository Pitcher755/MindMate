import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/home/provider/mood_history_provider.dart';
import 'package:mindmate/features/home/widgets/mood_history_full.dart';

class MoodHistoryPreview extends ConsumerWidget {
  const MoodHistoryPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodHistoryAsync = ref.watch(moodHistoryProvider);

    return moodHistoryAsync.when(
      data: (history) {
        if (history.isEmpty) {
          // Si no hay historial, muestra un recuadro sumple
          return Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'Sin historial de estados',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
          );
        }

        final latestMood = history.first;
        final mood = (latestMood['mood'] ?? 'Neutro').toString();
        final moodEmoji = _getMoodEmoji(mood);
        final date = (latestMood['date'] as DateTime?) ?? DateTime.now();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MoodHistoryFull(),
                ),
            );
          },
          child: Hero(
            tag: 'moodHistoryHero',
            child: Container(
              decoration: BoxDecoration(
                color: _getMoodColor(mood),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estado actual',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(moodEmoji, style: const TextStyle(fontSize: 46)),
                        const SizedBox(height: 2),
                        Text(
                          mood,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('dd MMM yyyy').format(date),
                          style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Ver más 🔎',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.errorRed.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: AppColors.errorRed),
          ),
        ),
      ),
    );
  }
   
  String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'feliz':
        return '😊';
      case 'tranquilo':
        return '😌';
      case 'estresado':
        return '😫';
      case 'triste':
        return '😢';
      case 'ansioso':
        return '😰';
      case 'motivado':
        return '💪';
      default:
        return '🙂';
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'feliz':
        return AppColors.primary;
      case 'tranquilo':
        return Colors.blueAccent;
      case 'estresado':
        return Colors.orangeAccent;
      case 'triste':
        return Colors.indigo;
      case 'ansioso':
        return Colors.pinkAccent;
      case 'motivado':
        return Colors.green;
      default:
        return AppColors.grey;
    }
  }
}
