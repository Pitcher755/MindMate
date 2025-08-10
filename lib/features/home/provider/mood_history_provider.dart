import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';
import 'package:mindmate/features/home/services/mood_history_service.dart';

final MoodHistoryServiceProvider = Provider(
  (ref) => MoodHistoryService(FirebaseFirestore.instance),
);

final moodHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  try {
    final user = await ref.watch(userDataProvider.future);
    return ref.read(MoodHistoryServiceProvider).getMoodHistory(uid: user.uid);
  } catch (e) {
    return [];
  }
});
