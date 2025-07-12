
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindmate/models/mood_quote_model.dart';

class MoodQuoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<MoodQuote>> fetchQuotesByMood(String mood) async {
    try {
      final query = await _db
          .collection('moodQuotes')
          .where('mood', isEqualTo: mood.toLowerCase())
          .get();

          return query.docs.map((doc) => MoodQuote.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching mood quotes: $e');
      return [];
    }
  }
}