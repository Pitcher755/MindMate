
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindmate/features/home/provider/mood_history_provider.dart';

class MoodHistoryFull extends ConsumerWidget{
  final String initialMood;

  const MoodHistoryFull({super.key, required this.initialMood});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      final historyAsync = ref.watch(moodHistoryProvider);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Historial de estados'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Hero(
          tag: 'moodHistoryHero',
          child: historyAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return const Center(
                  child: Text('No hay historial disponible')
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = history[index];
                  final mood = item['mood'] ?? 'Neutro';
                  final date = (item['date'] as DateTime?) ?? DateTime.now();

                  return Row(
                    children: [
                      Text(
                        _getMoodEmoji(mood),
                        style: const TextStyle(
                          fontSize: 30
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          mood,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(date),
                          style: const TextStyle(color: Colors.grey),
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