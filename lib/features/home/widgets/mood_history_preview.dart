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
    final moodHistoryAsync = ref.watch(moodHistoryProvider);

    return moodHistoryAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return _buildEmpty(context);
        }

        final recent = history.take(5).toList();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MoodHistoryFull()),
            );
          },
          child: Hero(
            tag: 'moodHistoryHero',
            child: Card(
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: recent.map((m) {
                    final mood = m['mood'] ?? 'neutro';
                    final date = m['date'] as DateTime;
                    final emoji = _getMoodEmoji(mood);
                    final bgColor = _getMoodColor(mood);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: bgColor.withValues(alpha: 0.2),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${date.day}/${date.month}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
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
