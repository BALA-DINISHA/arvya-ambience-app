import 'package:arvya_ambience_app/features/player/bloc/player_event.dart';
import 'package:arvya_ambience_app/features/player/bloc/player_states.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/ambience.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerBlocState> {

  final AudioPlayer _audioPlayer = AudioPlayer();
  Ambience? _lastActiveAmbience;

  PlayerBloc() : super(PlayerInitial()) {

    _audioPlayer.onPositionChanged.listen((position) {
      add(UpdateProgress(position: position));
    });

    /// Detect when audio finishes
    _audioPlayer.onPlayerComplete.listen((event) {
      add(const EndSession());
    });

    on<StartSession>(_onStartSession);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<SeekSession>(_onSeekSession);
    on<EndSession>(_onEndSession);
    on<UpdateProgress>(_onUpdateProgress);
  }

  /// START SESSION
  Future<void> _onStartSession(
      StartSession event,
      Emitter<PlayerBlocState> emit,
      ) async {

    _lastActiveAmbience = event.ambience;

    emit(PlayerLoading());

    try {

      await _audioPlayer.play(
        AssetSource("audio/${event.ambience.audioAsset}"),
      );

      emit(PlayerActive(
        ambience: event.ambience,
        isPlaying: true,
        position: Duration.zero,
        totalDuration: Duration(seconds: event.ambience.duration),
      ));

    } catch (e) {
      emit(const PlayerError("Audio failed to play"));
    }
  }

  /// PAUSE
  Future<void> _onPauseSession(
      PauseSession event,
      Emitter<PlayerBlocState> emit,
      ) async {

    await _audioPlayer.pause();

    if (state is PlayerActive) {
      final currentState = state as PlayerActive;

      emit(currentState.copyWith(isPlaying: false));
    }
  }

  /// RESUME
  Future<void> _onResumeSession(
      ResumeSession event,
      Emitter<PlayerBlocState> emit,
      ) async {

    await _audioPlayer.resume();

    if (state is PlayerActive) {
      final currentState = state as PlayerActive;

      emit(currentState.copyWith(isPlaying: true));
    }
  }

  /// SEEK
  Future<void> _onSeekSession(
      SeekSession event,
      Emitter<PlayerBlocState> emit,
      ) async {

    if (state is PlayerActive) {

      final currentState = state as PlayerActive;

      await _audioPlayer.seek(event.position);

      emit(currentState.copyWith(position: event.position));
    }
  }

  /// END SESSION
  Future<void> _onEndSession(
      EndSession event,
      Emitter<PlayerBlocState> emit,
      ) async {

    await _audioPlayer.stop();

    emit(PlayerEnded(lastAmbience: _lastActiveAmbience));
  }

  /// UPDATE PROGRESS
  void _onUpdateProgress(
      UpdateProgress event,
      Emitter<PlayerBlocState> emit,
      ) {

    if (state is PlayerActive && event.position != null) {

      final currentState = state as PlayerActive;

      emit(currentState.copyWith(
        position: event.position!,
      ));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}