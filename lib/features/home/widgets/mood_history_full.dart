import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/home/provider/mood_history_provider.dart';

class MoodHistoryFull extends ConsumerStatefulWidget {
  const MoodHistoryFull({super.key});

  @override
  ConsumerState<MoodHistoryFull> createState() => _MoodHistoryFullState();
}

class _MoodHistoryFullState extends ConsumerState<MoodHistoryFull> {
  // Estado para filtrar la vista (todo, semanal, rango de fechas)
  String _filterMode = 'todo';

  @override
  Widget build(BuildContext context) {
    final moodHistoryAsync = ref.watch(moodHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis estados de ánimo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Hero(
        tag: 'moodHistoryHero',
        child: moodHistoryAsync.when(
          data: (history) {
            if (history.isEmpty) {
              return const Center(child: Text('No hay historial disponible.'));
            }

            final filteredHistory = history;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredHistory.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = filteredHistory[index];
                final mood = (item['mood'] ?? 'Neutro').toString();
                final date = (item['date'] as DateTime?) ?? DateTime.now();

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _getMoodColor(mood).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getMoodEmoji(mood),
                        style: const TextStyle(fontSize: 44),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
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
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.list),
              tooltip: 'Ver todo',
              onPressed: () => setState(() => _filterMode = 'todo'),
              color: _filterMode == 'todo' ? AppColors.primary : null,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_view_week),
              tooltip: 'Ver semanal',
              onPressed: () => setState(() => _filterMode = 'semanal'),
              color: _filterMode == 'semanal' ? AppColors.primary : null,
            ),
            IconButton(
              icon: const Icon(Icons.date_range),
              tooltip: 'Filtrar por fecha',
              onPressed: () {
                // Abrir un Date picker para personalizar el rango de fechas, mas adelante
              },
              color: _filterMode == 'rango' ? AppColors.primary : null,
            ),
          ],
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
