import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String ambienceTitle;
  final String mood;
  final String text;
  final DateTime timestamp;

  const JournalEntry({
    required this.id,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'ambienceTitle': ambienceTitle,
    'mood': mood,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] ?? '',
      ambienceTitle: json['ambienceTitle'] ?? 'Unknown',
      mood: json['mood'] ?? 'Calm',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, timestamp];
}