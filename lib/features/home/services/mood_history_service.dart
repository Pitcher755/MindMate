
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodHistoryService {
  final FirebaseFirestore _firestore;

  MoodHistoryService(this._firestore);

  Future<List<Map<String, dynamic>>> getMoodHistory({required String uid}) async {
    final snapshot = await _firestore.
    collection('users')
    .doc(uid)
    .collection('moods')
    .orderBy('date', descending: true)
    .get();

    return snapshot.docs.map((doc) {
      return {
        'mood': doc['mood'] as String,
        'date': (doc['date'] as Timestamp).toDate(),
      };
    }).toList();
  }
}