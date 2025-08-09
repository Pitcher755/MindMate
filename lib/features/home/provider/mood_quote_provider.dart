import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Quote {
  final String text;

  Quote({required this.text});

  factory Quote.fromMap(Map<String, dynamic> data) {
    return Quote(text: data['text'] ?? '');
  }
  Map<String, dynamic> toMap() {
    return {'text': text};
  }
}

// Provider que devuelve una cita aleatoria de un mood concreto
final moodQuoteServiceProvider =
    FutureProvider.family<String, ({String mood, String userName})>((
      ref,
      params,
    ) async {
      final mood = params.mood.toLowerCase();
      final userName = params.userName;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('moodQuotes')
          .doc(mood)
          .get();

      if (!docSnapshot.exists) {
        return "No se encontró ninguna frase para este estado de ánimo.";
      }

      final Map<String, dynamic>? data = docSnapshot.data();
      if (data == null || data['quotes'] == null) {
        return "No hay frases disponibles.";
      }

      final quotesList = (data['quotes'] as List)
          .map((e) => Quote.fromMap(e as Map<String, dynamic>))
          .toList();

      if (quotesList.isEmpty) {
        return "No hay frases disponibles.";
      }

      // Frase aleatoria
      final randomQuote = quotesList[Random().nextInt(quotesList.length)].text;

      // Reemplazo de $name
      return randomQuote.replaceAll("\$name", userName);
    });
