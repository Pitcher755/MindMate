import 'package:flutter/material.dart';
import 'package:mindmate/features/home/screen/technique_full_screen.dart';
import 'package:mindmate/models/technique_model.dart';

class TechniquePreviewWidget extends StatelessWidget {
  final Technique technique;

  const TechniquePreviewWidget({Key? key, required this.technique})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: TechniqueFullScreen(technique: technique),
              );
            },
          ),
        );
      },
      child: Hero(
        tag: 'technique_${technique.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  technique.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
