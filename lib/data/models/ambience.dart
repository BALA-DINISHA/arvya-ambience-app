import 'package:equatable/equatable.dart';

class Ambience extends Equatable {
  final String id;
  final String title;
  final String tag;
  final int duration; // in seconds
  final String thumbnailUrl;
  final String description;
  final List<String> sensoryChips;
  final String audioAsset;

  const Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.duration,
    required this.thumbnailUrl,
    required this.description,
    required this.sensoryChips,
    required this.audioAsset,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'],
      title: json['title'],
      tag: json['tag'],
      duration: json['duration'],
      thumbnailUrl: json['thumbnailUrl'],
      description: json['description'],
      sensoryChips: List<String>.from(json['sensoryChips']),
      audioAsset: json['audioAsset'],
    );
  }

  @override
  List<Object?> get props => [id, title, tag];
}