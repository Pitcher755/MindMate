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
  String _filterMode = 'todo';
  DateTimeRange? _selectedRange;

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

            final filteredHistory = _applyFilter(history);

            return Stack(
              children: [
                // Línea vertical en el centro para la línea de vida
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(width: 3, color: Colors.grey.shade300),
                  ),
                ),

                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) {
                    final item = filteredHistory[index];
                    final mood = (item['mood'] ?? 'Neutro').toString();
                    final date = (item['date'] as DateTime?) ?? DateTime.now();
                    final moodColor = _getMoodColor(
                      mood,
                    ).withValues(alpha: 0.2);
                    final isLeft = index % 2 == 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Emoji y fecha (siempre centrados)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getMoodEmoji(mood),
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd MMM yyyy').format(date),
                                  style: const TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            // Texto del mood (Izquierda o derecha)
                            Padding(
                              padding: const EdgeInsets.only(left: 60, right: 60),
                              child: Align(
                                alignment: isLeft
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 100,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: moodColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    mood,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() => _filterMode = 'todo'),
                child: _buildFilterOption('📋 Todo', 'todo'),
              ),
              GestureDetector(
                onTap: () => setState(() => _filterMode = 'semanal'),
                child: _buildFilterOption('📅 Semanal', 'semanal'),
              ),
              GestureDetector(
                onTap: _selectedDateOrRange,
                child: _buildFilterOption('📅 Rango', 'rango'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, String mode) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 20,
        color: _filterMode == mode ? AppColors.primary : AppColors.grey,
        fontWeight: _filterMode == mode ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  List<Map<String, dynamic>> _applyFilter(List<Map<String, dynamic>> history) {
    if (_filterMode == 'semanal') {
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 7));
      return history
          .where((item) => (item['date'] as DateTime).isAfter(lastWeek))
          .toList();
    } else if (_filterMode == 'rango' && _selectedRange != null) {
      return history
          .where(
            (item) =>
                (item['date'] as DateTime).isAfter(
                  _selectedRange!.start.subtract(const Duration(days: 1)),
                ) &&
                (item['date'] as DateTime).isBefore(
                  _selectedRange!.end.add(const Duration(days: 1)),
                ),
          )
          .toList();
    }
    return history;
  }

  Future<void> _selectedDateOrRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialDateRange:
          _selectedRange ??
          DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        _filterMode = 'rango';
        _selectedRange = picked;
      });
    }
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
