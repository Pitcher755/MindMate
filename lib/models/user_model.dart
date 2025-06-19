import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? profileImageUrl;
  final List<String> goals;
  final DateTime createdAt;
  final bool isAnonymous;
  final List<String>? completedChallenges;
  final List<Map<String, dynamic>>? moodHistory;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.goals,
    required this.createdAt,
    required this.isAnonymous,
    this.profileImageUrl,
    this.completedChallenges,
    this.moodHistory,
  });

  // Serializar el modelo para subirlo a Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'goals': goals,
      'createdAt': createdAt.toIso8601String(),
      'isAnonymoud': isAnonymous,
      'completedChallenges': completedChallenges ?? [],
      'moodHistory': moodHistory ?? [],
    };
  }

  // Crea una instancia desde un snapshot de Firestore
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      goals: List<String>.from(data['goals']),
      createdAt: DateTime.parse(data['createdAt']),
      isAnonymous: data['isAnonymous'] ?? false,
      completedChallenges: (data['completedChallenges'] as List?)
          ?.cast<String>(),
      moodHistory: (data['moodHistory'] as List?)
          ?.cast<Map<String, dynamic>>(),
    );
  }
}
