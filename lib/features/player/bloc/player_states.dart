
// Rename from PlayerState to PlayerBlocState to avoid conflict with audioplayers PlayerState
import 'package:equatable/equatable.dart';

import '../../../data/models/ambience.dart';

abstract class PlayerBlocState extends Equatable {
  const PlayerBlocState();

  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerBlocState {}

class PlayerLoading extends PlayerBlocState {}

class PlayerActive extends PlayerBlocState {
  final Ambience ambience;
  final bool isPlaying;
  final Duration position;
  final Duration totalDuration;
  const PlayerActive({
    required this.ambience,
    required this.isPlaying,
    required this.position,
    required this.totalDuration,
  });

  PlayerActive copyWith({
    Ambience? ambience,
    bool? isPlaying,
    Duration? position,
    Duration? totalDuration,
  }) {
    return PlayerActive(
      ambience: ambience ?? this.ambience,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  @override
  List<Object> get props => [ambience, isPlaying, position, totalDuration];
}

class PlayerEnded extends PlayerBlocState {
  final Ambience? lastAmbience;

  const PlayerEnded({this.lastAmbience});

  @override
  List<Object> get props => [lastAmbience ?? ''];
}

class PlayerError extends PlayerBlocState {
  final String message;

  const PlayerError(this.message);

  @override
  List<Object> get props => [message];
}