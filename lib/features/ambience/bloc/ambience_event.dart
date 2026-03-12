
import 'package:equatable/equatable.dart';

abstract class AmbienceEvent extends Equatable {
  const AmbienceEvent();

  @override
  List<Object> get props => [];
}

class LoadAmbiences extends AmbienceEvent {}

class FilterAmbiences extends AmbienceEvent {
  final String? searchQuery;
  final String? selectedTag;

  const FilterAmbiences({this.searchQuery, this.selectedTag});

  @override
  List<Object> get props => [searchQuery ?? '', selectedTag ?? ''];
}

class SelectAmbience extends AmbienceEvent {
  final String ambienceId;

  const SelectAmbience(this.ambienceId);

  @override
  List<Object> get props => [ambienceId];
}