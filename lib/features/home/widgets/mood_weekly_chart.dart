import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodWeeklyChart extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyHistory;
  final Color Function(String) getMoodColor;
  final String Function(String) getMoodEmoji;

  const MoodWeeklyChart({
    super.key,
    required this.weeklyHistory,
    required this.getMoodColor,
    required this.getMoodEmoji,
  });

  @override
  State<MoodWeeklyChart> createState() => _MooodWeeklyChartState();
}

class _MooodWeeklyChartState extends State<MoodWeeklyChart> {
  bool _showChart = true;

  // Ranking de moods ( de peor a mejor -> altura)
  final Map<String, double> _moodRank = {
    'triste': 1.0,
    'ansioso': 2.0,
    'estresado': 3.0,
    'tranquilo': 4.0,
    'motivado': 5.0,
    'feliz': 6.0,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _showChart ? _buildChart(context) : _buildTimeline(context),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: IconButton(
            icon: Icon(_showChart ? Icons.list_alt : Icons.bar_chart),
            onPressed: () => setState(() => _showChart = !_showChart),
          ),
        ),
      ],
    );
  }

  // Vista de gráfico
  Widget _buildChart(BuildContext context) {
    final maxY = 7.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = constraints.maxHeight - 40;

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 ||
                              index >= widget.weeklyHistory.length) {
                            return const SizedBox.shrink();
                          }
                          final date =
                              widget.weeklyHistory[index]['date'] as DateTime;
                          return Text(
                            DateFormat.E(
                              Localizations.localeOf(context).toString(),
                            ).format(date),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: widget.weeklyHistory.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final mood = (item['mood'] ?? 'Neutro')
                        .toString()
                        .toLowerCase();
                    final moodRank = _moodRank[mood] ?? 0;
                    final color = widget.getMoodColor(mood);

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: moodRank,
                          color: color,
                          width: 22,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            // Emojis encima de cada barra
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  final barWidth =
                      boxConstraints.maxWidth / widget.weeklyHistory.length;

                  return Stack(
                    children: widget.weeklyHistory.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final mood = (item['mood'] ?? 'Neutro')
                          .toString()
                          .toLowerCase();
                      final moodRank = _moodRank[mood] ?? 0;
                      final emoji = widget.getMoodEmoji(mood);

                      final x = (barWidth * index) + barWidth / 2 - 15.5;
                      final y = chartHeight * (1 - (moodRank / maxY)) - 24;

                      return Positioned(
                        left: x,
                        top: y,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Vista timeline
  Widget _buildTimeline(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(width: 3, color: Colors.grey.shade300),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: widget.weeklyHistory.length,
          itemBuilder: (context, index) {
            final item = widget.weeklyHistory[index];
            final mood = (item['mood'] ?? 'Neutro').toString();
            final date = item['date'] as DateTime;
            final moodColor = widget.getMoodColor(mood).withValues(alpha: 0.2);
            final isLeft = index % 2 == 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.getMoodEmoji(mood),
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy').format(date),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60),
                      child: Align(
                        alignment: isLeft
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 100),
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
  }
}
