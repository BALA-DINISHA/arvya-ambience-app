
import 'package:arvya_ambience_app/data/models/ambience.dart';
import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class StartSession extends PlayerEvent {
  final Ambience ambience;

  const StartSession(this.ambience);

  @override
  List<Object> get props => [ambience];
}

class PauseSession extends PlayerEvent {
  const PauseSession();
}

class ResumeSession extends PlayerEvent {
  const ResumeSession();
}

class SeekSession extends PlayerEvent {
  final Duration position;

  const SeekSession(this.position);

  @override
  List<Object> get props => [position];
}

class EndSession extends PlayerEvent {
  final String? ambienceTitle;

  const EndSession({this.ambienceTitle});

  @override
  List<Object> get props => [ambienceTitle ?? ''];
}

class UpdateProgress extends PlayerEvent {
  final Duration? position;

  const UpdateProgress({this.position});

  @override
  List<Object> get props => [position ?? Duration.zero];
}