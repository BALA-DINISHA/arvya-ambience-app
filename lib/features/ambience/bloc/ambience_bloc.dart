import 'dart:async';

import 'package:arvya_ambience_app/features/ambience/bloc/ambience_event.dart';
import 'package:arvya_ambience_app/features/ambience/bloc/ambience_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/ambience.dart';
import '../../../data/repository/ambience_repository.dart';

class AmbienceBloc extends Bloc<AmbienceEvent, AmbienceState> {
  final AmbienceRepository repository;

  AmbienceBloc({required this.repository}) : super(AmbienceInitial()) {
    on<LoadAmbiences>(_onLoadAmbiences);
    on<FilterAmbiences>(_onFilterAmbiences);
    on<SelectAmbience>(_onSelectAmbience);
  }

  Future<void> _onLoadAmbiences(
      LoadAmbiences event,
      Emitter<AmbienceState> emit
      ) async {
    emit(AmbienceLoading());
    try {
      final ambiences = await repository.loadAmbiences();
      print('Loaded ${ambiences.length} ambiences'); // Debug print
      emit(AmbienceLoaded(
        allAmbiences: ambiences,
        filteredAmbiences: ambiences,
      ));
    } catch (e) {
      print('Error loading ambiences: $e'); // Debug print
      emit(AmbienceError(e.toString()));
    }
  }

  void _onFilterAmbiences(
      FilterAmbiences event,
      Emitter<AmbienceState> emit
      ) {
    if (state is AmbienceLoaded) {
      final currentState = state as AmbienceLoaded;

      List<Ambience> filtered = List.from(currentState.allAmbiences);

      // Apply tag filter
      if (event.selectedTag != null && event.selectedTag!.isNotEmpty) {
        filtered = filtered.where((a) => a.tag == event.selectedTag).toList();
      }

      // Apply search filter
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        filtered = filtered.where((a) =>
            a.title.toLowerCase().contains(event.searchQuery!.toLowerCase())
        ).toList();
      }

      print('Filtered to ${filtered.length} ambiences'); // Debug print

      emit(AmbienceLoaded(
        allAmbiences: currentState.allAmbiences,
        filteredAmbiences: filtered,
        searchQuery: event.searchQuery,
        selectedTag: event.selectedTag,
      ));
    }
  }

  void _onSelectAmbience(
      SelectAmbience event,
      Emitter<AmbienceState> emit
      ) {
    // Navigation handled by UI
  }
}