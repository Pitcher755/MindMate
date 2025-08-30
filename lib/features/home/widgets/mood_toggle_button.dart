import 'package:flutter/material.dart';

class MoodToggleButton extends StatelessWidget {
  final bool showChart;
  final VoidCallback onPressed;

  const MoodToggleButton({
    Key? key,
    required this.showChart,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(
          showChart ? Icons.list_alt : Icons.bar_chart,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: onPressed,
        ),
    );
  }
}
