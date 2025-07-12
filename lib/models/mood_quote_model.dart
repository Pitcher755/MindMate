class MoodQuote {
  final String text;
  final String mood;

  MoodQuote({required this.text, required this.mood});

  factory MoodQuote.fromMap(Map<String, dynamic> data) {
    return MoodQuote(text: data['text'] ?? '', mood: data['mood'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'mood': mood};
  }
}
