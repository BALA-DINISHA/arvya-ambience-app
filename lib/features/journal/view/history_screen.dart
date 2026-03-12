import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/journal_entry.dart';
import '../bloc/journal_bloc.dart';
import '../../../shared/widgets/empty_state.dart';
import '../bloc/journel_event.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalBloc>().add( LoadJournalEntries());
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2B3A)),
      onPressed: () {
        // Always go to home screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
              (route) => false, // This removes all routes and pushes home
        );
      },
    ),
        title: const Text(
          'Journal History',
          style: TextStyle(
            color: Color(0xFF1E2B3A),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          print('Journal State: $state'); // Debug print

          if (state is JournalLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D5A4B)),
              ),
            );
          }

          if (state is JournalLoaded) {
            print('Loaded ${state.entries.length} entries'); // Debug print

            if (state.entries.isEmpty) {
              return EmptyState(
                message: 'No reflections yet. Start a session to begin.',
                onClearFilters: () {
                  // Navigate to home screen
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                        (route) => false,
                  );
                },
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
                final entry = state.entries[index];
                return _buildJournalCard(context, entry);
              },
            );
          }

          if (state is JournalError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<JournalBloc>().add( LoadJournalEntries());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5A4B),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Initial state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading journal entries...',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildJournalCard(BuildContext context, JournalEntry entry) {
    return GestureDetector(
      onTap: () {
        context.read<JournalBloc>().add(
          SelectJournalEntry(entry.id),
        );
        Navigator.pushNamed(context, '/entry-detail');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with mood and date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getMoodColor(entry.mood).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getMoodIcon(entry.mood),
                          size: 14,
                          color: _getMoodColor(entry.mood),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          entry.mood,
                          style: TextStyle(
                            color: _getMoodColor(entry.mood),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(entry.timestamp),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Ambience title
              Row(
                children: [
                  Icon(
                    Icons.spa,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      entry.ambienceTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E2B3A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Journal preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.text.isEmpty
                      ? 'No reflection text...'
                      : (entry.text.length > 100
                      ? '${entry.text.substring(0, 100)}...'
                      : entry.text),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // View details indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View details',
                    style: TextStyle(
                      fontSize: 12,
                      color: _getMoodColor(entry.mood),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: _getMoodColor(entry.mood),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'Calm':
        return Icons.sentiment_very_satisfied;
      case 'Grounded':
        return Icons.terrain;
      case 'Energized':
        return Icons.flash_on;
      case 'Sleepy':
        return Icons.nightlight;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Calm':
        return const Color(0xFF4A90E2); // Blue
      case 'Grounded':
        return const Color(0xFF50C878); // Green
      case 'Energized':
        return const Color(0xFFF39C12); // Orange
      case 'Sleepy':
        return const Color(0xFF9B59B6); // Purple
      default:
        return const Color(0xFF95A5A6); // Gray
    }
  }
}