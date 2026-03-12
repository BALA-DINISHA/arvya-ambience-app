import 'dart:async';
import 'package:arvya_ambience_app/features/player/bloc/player_event.dart';
import 'package:arvya_ambience_app/features/player/bloc/player_states.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/ambience.dart';


class PlayerBloc extends Bloc<PlayerEvent, PlayerBlocState> {
  Timer? _timer;
  Ambience? _lastActiveAmbience;
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerBloc() : super(PlayerInitial()) {
    on<StartSession>(_onStartSession);
    on<PauseSession>(_onPauseSession);
    on<ResumeSession>(_onResumeSession);
    on<SeekSession>(_onSeekSession);
    on<EndSession>(_onEndSession);
    on<UpdateProgress>(_onUpdateProgress);
  }
  Future<void> _onStartSession(StartSession event, Emitter<PlayerBlocState> emit) async {
    _timer?.cancel();
    _lastActiveAmbience = event.ambience;

    emit(PlayerLoading());

    await Future.delayed(const Duration(milliseconds: 300));

    try {

      await _audioPlayer.play(
          AssetSource("audio/${event.ambience.audioAsset}")
      );

      emit(PlayerActive(
        ambience: event.ambience,
        isPlaying: true,
        position: Duration.zero,
        totalDuration: Duration(seconds: event.ambience.duration),
      ));

      _startTimer();

    } catch (e) {
      emit(PlayerError("Audio failed to play"));
    }
  }
  void _onPauseSession(PauseSession event, Emitter<PlayerBlocState> emit) async {
    _timer?.cancel();

    await _audioPlayer.pause();

    if (state is PlayerActive) {
      final currentState = state as PlayerActive;
      emit(currentState.copyWith(isPlaying: false));
    }
  }

  void _onResumeSession(ResumeSession event, Emitter<PlayerBlocState> emit) async {

    if (state is PlayerActive) {
      final currentState = state as PlayerActive;

      await _audioPlayer.resume();

      emit(currentState.copyWith(isPlaying: true));
      _startTimer();
    }
  }
  void _onSeekSession(SeekSession event, Emitter<PlayerBlocState> emit) {
    print('⏩ SeekSession event received: ${event.position}');

    if (state is PlayerActive) {
      final currentState = state as PlayerActive;
      if (event.position <= currentState.totalDuration) {
        emit(currentState.copyWith(position: event.position));
        print('✅ Emitted seeked state');
      }
    }
  }

  void _onEndSession(EndSession event, Emitter<PlayerBlocState> emit) async {
    _timer?.cancel();

    await _audioPlayer.stop();

    emit(PlayerEnded(lastAmbience: _lastActiveAmbience));
  }
  void _onUpdateProgress(UpdateProgress event, Emitter<PlayerBlocState> emit) {
    if (state is PlayerActive) {
      final currentState = state as PlayerActive;

      if (currentState.isPlaying) {
        final newPosition = currentState.position + const Duration(seconds: 1);

        if (newPosition >= currentState.totalDuration) {
          print('⏰ Session completed - total duration reached');
          _timer?.cancel();
          add(const EndSession());
        } else {
          emit(currentState.copyWith(position: newPosition));
        }
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(const UpdateProgress());
    });
    print('⏱️ Timer started');
  }

  @override
  Future<void> close() {
    print('🔚 Closing PlayerBloc');
    _timer?.cancel();
    return super.close();
  }
}