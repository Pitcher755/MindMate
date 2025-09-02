class Technique {
  final String id;
  final String title;
  final String description;
  final int durationSeconds;
  final List<String> steps;

  const Technique({
    required this.id,
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.steps,
  });

  // Duración como objeto [Duration]
  Duration get duration => Duration(seconds: durationSeconds);

  // Crea una instancia desde un 'Map'
  factory Technique.fromMap(Map<String, dynamic> map, {required String id}) {
    return Technique(
      id: id,
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      durationSeconds: _toInt(map['duration']),
      steps: _parseSteps(map['steps']),
    );
  }

  // Convierte la instancia a 'Map'
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': durationSeconds,
      'steps': steps,
    };
  }

  Technique copyWith({
    String? id,
    String? title,
    String? description,
    int? durationSeconds,
    List<String>? steps,
  }) {
    return Technique(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      steps: steps ?? this.steps,
    );
  }

  @override
  String toString() =>
      'Technique(id: $id, title: $title, duration: ${duration.inMinutes}m, steps: ${steps.length})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Technique &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.durationSeconds == durationSeconds &&
        _listEquals(other.steps, steps);
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      durationSeconds.hashCode ^
      steps.hashCode;

  // ---- helpers privados ----
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static List<String> _parseSteps(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return const <String>[];
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
