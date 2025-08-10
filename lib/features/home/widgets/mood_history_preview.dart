import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/home/provider/mood_history_provider.dart';
import 'package:mindmate/features/home/widgets/mood_history_full.dart';

class MoodHistoryPreview extends ConsumerWidget {
  const MoodHistoryPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(moodHistoryProvider);

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return _buildEmpty(context);
        }

        final latestMood = history.first;
        final mood = latestMood['mood'] ?? 'Neutro';
        final moodEmoji = _getMoodEmoji(mood);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MoodHistoryFull(initialMood: mood),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(moodEmoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    mood,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildError(e.toString()),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('Sin historial', style: TextStyle(color: AppColors.grey)),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Error: $message',
          style: const TextStyle(color: AppColors.errorRed),
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
