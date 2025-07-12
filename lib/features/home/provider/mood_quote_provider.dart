

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/features/home/services/mood_quote_service.dart';
import 'package:mindmate/models/mood_quote_model.dart';

final moodQuoteServiceProvider = Provider((ref) => MoodQuoteService());

final moodQuoteByMoodProvider =
  FutureProvider.family<List<MoodQuote>, String>((ref, mood) {
    final service = ref.read(moodQuoteServiceProvider);
    return service.fetchQuotesByMood(mood);
  });