

import 'package:equatable/equatable.dart';

import '../../../data/models/ambience.dart' show Ambience;

abstract class AmbienceState extends Equatable {
  const AmbienceState();

  @override
  List<Object> get props => [];
}

class AmbienceInitial extends AmbienceState {}

class AmbienceLoading extends AmbienceState {}

class AmbienceLoaded extends AmbienceState {
  final List<Ambience> allAmbiences;
  final List<Ambience> filteredAmbiences;
  final String? searchQuery;
  final String? selectedTag;

  const AmbienceLoaded({
    required this.allAmbiences,
    required this.filteredAmbiences,
    this.searchQuery,
    this.selectedTag,
  });

  @override
  List<Object> get props => [allAmbiences, filteredAmbiences, searchQuery ?? '', selectedTag ?? ''];
}

class AmbienceError extends AmbienceState {
  final String message;

  const AmbienceError(this.message);

  @override
  List<Object> get props => [message];
}