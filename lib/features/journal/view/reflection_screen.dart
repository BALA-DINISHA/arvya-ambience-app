import 'package:arvya_ambience_app/features/journal/bloc/journel_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../player/bloc/player_bloc.dart';
import '../../player/bloc/player_states.dart';
import '../bloc/journal_bloc.dart';
import '../../../data/models/journal_entry.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final textController = TextEditingController();
  String selectedMood = 'Calm';

  @override
  Widget build(BuildContext context) {
    // Get ambience title from arguments FIRST
    String ambienceTitle = 'Unknown';

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      ambienceTitle = args;
      print('Got title from arguments: $ambienceTitle');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reflection',
          style: TextStyle(
            color: Color(0xFF1E2B3A),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2B3A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // Fix overflow issue
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: const Text(
                  'What is gently present with you right now?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                    color: Color(0xFF1E2B3A),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Show which ambience you're reflecting on
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getMoodColor(selectedMood).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.spa,
                      color: _getMoodColor(selectedMood),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reflecting on:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5A6B7A),
                            ),
                          ),
                          Text(
                            ambienceTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E2B3A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Text input label
              const Text(
                'Your thoughts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E2B3A),
                ),
              ),
              const SizedBox(height: 8),

              // Text input
              Container(
                height: 150, // Fixed height instead of maxLines
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: textController,
                  maxLines: null, // Makes it multiline
                  expands: true, // Fills the container
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(
                    color: Color(0xFF1E2B3A),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF2D5A4B), width: 1),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Mood selector label
              const Text(
                'How do you feel?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E2B3A),
                ),
              ),
              const SizedBox(height: 12),

              // Mood selector
              Row(
                children: [
                  _buildMoodChip('Calm', selectedMood, (mood) {
                    setState(() {
                      selectedMood = mood;
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildMoodChip('Grounded', selectedMood, (mood) {
                    setState(() {
                      selectedMood = mood;
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildMoodChip('Energized', selectedMood, (mood) {
                    setState(() {
                      selectedMood = mood;
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildMoodChip('Sleepy', selectedMood, (mood) {
                    setState(() {
                      selectedMood = mood;
                    });
                  }),
                ],
              ),

              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final entry = JournalEntry(
                      id: const Uuid().v4(),
                      ambienceTitle: ambienceTitle,
                      mood: selectedMood,
                      text: textController.text,
                      timestamp: DateTime.now(),
                    );

                    print('Saving entry with title: $ambienceTitle');
                    context.read<JournalBloc>().add(SaveJournalEntry(entry));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reflection saved for $ambienceTitle'),
                        backgroundColor: _getMoodColor(selectedMood),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/history',
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getMoodColor(selectedMood),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Reflection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodChip(String mood, String selectedMood, Function(String) onTap) {
    final isSelected = selectedMood == mood;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(mood),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _getMoodColor(mood) : Colors.grey[100],
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? _getMoodColor(mood) : Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: _getMoodColor(mood).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              mood,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1E2B3A),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Calm':
        return const Color(0xFF4A90E2);
      case 'Grounded':
        return const Color(0xFF50C878);
      case 'Energized':
        return const Color(0xFFF39C12);
      case 'Sleepy':
        return const Color(0xFF9B59B6);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}