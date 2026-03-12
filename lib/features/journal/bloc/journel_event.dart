
import 'package:arvya_ambience_app/data/models/journal_entry.dart';
import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object> get props => [];
}

class LoadJournalEntries extends JournalEvent {}

class SaveJournalEntry extends JournalEvent {
  final JournalEntry entry;

  const SaveJournalEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

class SelectJournalEntry extends JournalEvent {
  final String entryId;

  const SelectJournalEntry(this.entryId);

  @override
  List<Object> get props => [entryId];
}