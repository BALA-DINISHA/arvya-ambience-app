import 'package:arvya_ambience_app/data/repository/journal_repository.dart';
import 'package:arvya_ambience_app/features/journal/bloc/journel_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/journal_entry.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository repository;

  JournalBloc({required this.repository}) : super(JournalInitial()) {
    on<LoadJournalEntries>(_onLoadEntries);
    on<SaveJournalEntry>(_onSaveEntry);
    on<SelectJournalEntry>(_onSelectEntry);
  }

  Future<void> _onLoadEntries(
      LoadJournalEntries event,
      Emitter<JournalState> emit
      ) async {
    emit(JournalLoading());
    try {
      final entries = repository.getAllEntries();
      emit(JournalLoaded(entries: entries));
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }

  Future<void> _onSaveEntry(
      SaveJournalEntry event,
      Emitter<JournalState> emit
      ) async {
    try {
      await repository.saveEntry(event.entry);
      final entries = repository.getAllEntries();
      emit(JournalLoaded(entries: entries));
    } catch (e) {
      emit(JournalError(e.toString()));
    }
  }

  void _onSelectEntry(
      SelectJournalEntry event,
      Emitter<JournalState> emit
      ) {
    if (state is JournalLoaded) {
      final currentState = state as JournalLoaded;
      try {
        final entry = currentState.entries.firstWhere(
              (e) => e.id == event.entryId,
        );
        emit(JournalEntrySelected(entry: entry));
      } catch (e) {
        emit(JournalError('Entry not found'));
      }
    }
  }
}