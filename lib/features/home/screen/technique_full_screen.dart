import 'package:flutter/material.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/models/technique_model.dart';

class TechniqueFullScreen extends StatelessWidget {
  final Technique technique;

  const TechniqueFullScreen({Key? key, required this.technique})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Hero(
        tag: 'technique_${technique.id}',
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      technique.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Aquí el futuro reproducir sonido al iniciar ejercicio
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(">>Comenzar!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
