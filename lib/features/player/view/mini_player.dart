import 'package:arvya_ambience_app/features/player/bloc/player_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_states.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerBlocState>(
      builder: (context, state) {
        if (state is! PlayerActive) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/player'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTagColor(state.ambience.tag).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForTag(state.ambience.tag),
                    color: _getTagColor(state.ambience.tag),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Title and progress
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.ambience.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1E2B3A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: state.position.inSeconds /
                              state.totalDuration.inSeconds,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            _getTagColor(state.ambience.tag),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Play/Pause button
                Container(
                  decoration: BoxDecoration(
                    color: _getTagColor(state.ambience.tag).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      state.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 20,
                    ),
                    color: _getTagColor(state.ambience.tag),
                    onPressed: () {
                      if (state.isPlaying) {
                        context.read<PlayerBloc>().add(const PauseSession());
                      } else {
                        context.read<PlayerBloc>().add(const ResumeSession());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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