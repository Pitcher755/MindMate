import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/home/provider/mood_history_provider.dart';

class MoodHistoryFull extends ConsumerWidget {
  const MoodHistoryFull({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodHistoryAsync = ref.watch(moodHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de estados'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Hero(
        tag: 'moodHistoryHero',
        child: moodHistoryAsync.when(
          data: (history) {
            if (history.isEmpty) {
              return const Center(child: Text('No hay historial disponible'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final mood = item['mood'] ?? 'Neutro';
                final date = (item['date'] as DateTime?) ?? DateTime.now();
                final emoji = _getMoodEmoji(mood);

                final isLast = index == history.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          child: Text(emoji, style: TextStyle(fontSize: 18)),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.grey.shade300,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mood,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(date),
                              style: const TextStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
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
}
