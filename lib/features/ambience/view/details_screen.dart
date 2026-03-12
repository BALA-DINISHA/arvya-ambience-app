import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../player/bloc/player_bloc.dart';
import '../../../data/models/ambience.dart';
import '../../player/bloc/player_event.dart';

class DetailsScreen extends StatelessWidget {
  final Ambience ambience;
  const DetailsScreen({super.key,required this.ambience});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getTagColor(ambience.tag).withOpacity(0.3),
                      Colors.white,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: _getTagColor(ambience.tag).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForTag(ambience.tag),
                      size: 70,
                      color: _getTagColor(ambience.tag),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Tag
                  Text(
                    ambience.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2B3A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getTagColor(ambience.tag).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          ambience.tag,
                          style: TextStyle(
                            color: _getTagColor(ambience.tag),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${ambience.duration ~/ 60} min',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E2B3A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ambience.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5A6B7A),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sensory Experience
                  const Text(
                    'Sensory Experience',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E2B3A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ambience.sensoryChips.map((chip) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          chip,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PlayerBloc>().add(StartSession(ambience));
                        Navigator.pushNamed(context, '/player');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getTagColor(ambience.tag),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start Session',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTag(String tag) {
    switch (tag) {
      case 'Focus':
        return Icons.forest;
      case 'Calm':
        return Icons.waves;
      case 'Sleep':
        return Icons.nightlight;
      case 'Reset':
        return Icons.refresh;
      default:
        return Icons.spa;
    }
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Focus':
        return const Color(0xFF4A90E2);
      case 'Calm':
        return const Color(0xFF50C878);
      case 'Sleep':
        return const Color(0xFF9B59B6);
      case 'Reset':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF95A5A6);
    }
  }
}