
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TechniquesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Obtiene una técnica random evitando repetidas
  Future<Map<String, dynamic>?> getRandomTechniqueForUser() async {

    final user = _auth.currentUser;
    if (user == null) return null;

    // Obtiene todas las técnicas
    final snapshot = await _db.collection('techniques').get();
    final all = snapshot.docs.map((d) => {
      "id": d.id,
      ...d.data(),
    }).toList();

    // Obtiene las técnicas ya completadas por el usuario
    final userDoc = await _db.collection('users').doc(user.uid).get();
    final completed = List<String>.from(userDoc.data()?['completedTeChniques'] ?? []);

    // Filtra solo las que faltan
    final remaining = all.where((t) => !completed.contains(t['id'])).toList();

    if (remaining.isEmpty) {
      return null; // Ya completó todas las técnicas
    }

    // Devuelve una random de las pendientes
    return remaining[Random().nextInt(remaining.length)];
  }

  // Marca una técnica como completada por el usuario
  Future<void> markTechniqueAsCompleted(String techniqueId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'completedTechniques': FieldValue.arrayUnion([techniqueId]),
    });
  }

  // Reinicia el progreso del usuario chuando todas completas
  Future<void> resetUserTechniques() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'completedTechniques': [],
    });
  }

  
}