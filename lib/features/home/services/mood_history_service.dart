import 'package:cloud_firestore/cloud_firestore.dart';

class MoodHistoryService {
  final FirebaseFirestore _firestore;

  MoodHistoryService(this._firestore);

  Future<List<Map<String, dynamic>>> getMoodHistory({
    required String uid,
  }) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null || !data.containsKey('moodHistory')) return [];

    final List<dynamic> rawHistory = data['moodHistory'];

    final history = rawHistory.map<Map<String, dynamic>>((item) {
      final ts = item['date'];
      DateTime date;
      if (ts is Timestamp) {
        date = ts.toDate();
      } else if (ts is DateTime) {
        date = ts;
      } else {
        date = DateTime.now();
      }

      return {'date': date, 'mood': item['mood'] ?? 'Neutro'};
    }).toList();

    // Ordena de más reciente a mas antiguo
    history.sort((a, b) => b['date'].compareTo(a['date']));

    return history;
  }
}
