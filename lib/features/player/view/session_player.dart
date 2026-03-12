import 'package:arvya_ambience_app/features/player/bloc/player_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_states.dart';

class SessionPlayer extends StatelessWidget {
  const SessionPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerBlocState>(
      listener: (context, state) {
        print('📱 SessionPlayer listener state: $state');
        if (state is PlayerEnded) {
          String? ambienceTitle = state.lastAmbience?.title;
          if (ambienceTitle != null) {
            Navigator.pushReplacementNamed(
              context,
              '/reflection',
              arguments: ambienceTitle,
            );
          } else {
            Navigator.pushReplacementNamed(context, '/reflection');
          }
        }
      },
      builder: (context, state) {
        print('🎨 SessionPlayer builder state: $state');

        if (state is PlayerLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D5A4B)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Starting your session...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PlayerActive) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_downward, size: 24),
                          onPressed: () => Navigator.pop(context),
                          color: const Color(0xFF1E2B3A),
                        ),
                        Text(
                          state.ambience.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E2B3A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () {
                            _showEndDialog(context, state.ambience.title);
                          },
                          color: const Color(0xFF1E2B3A),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Animated Visual
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    builder: (context, double value, child) {
                      return Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _getTagColor(state.ambience.tag).withOpacity(0.3),
                              _getTagColor(state.ambience.tag).withOpacity(0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.2, 0.6, 1.0],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: _getTagColor(state.ambience.tag).withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              _getIconForTag(state.ambience.tag),
                              size: 70,
                              color: _getTagColor(state.ambience.tag),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Controls
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Time display
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(state.position),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E2B3A),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.grey[300],
                              ),
                              Text(
                                _formatDuration(state.totalDuration),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Seek bar
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 24,
                            ),
                            activeTrackColor: _getTagColor(state.ambience.tag),
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: _getTagColor(state.ambience.tag),
                          ),
                          child: Slider(
                            value: state.position.inSeconds
                                .toDouble()
                                .clamp(0, state.totalDuration.inSeconds.toDouble()),
                            min: 0,
                            max: state.totalDuration.inSeconds.toDouble(),
                            onChanged: (value) {
                              context.read<PlayerBloc>().add(
                                SeekSession(Duration(seconds: value.toInt())),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Play/Pause button
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getTagColor(state.ambience.tag).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (state.isPlaying) {
                                  context.read<PlayerBloc>().add(const PauseSession());
                                } else {
                                  context.read<PlayerBloc>().add(const ResumeSession());
                                }
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  state.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 70,
                                  color: _getTagColor(state.ambience.tag),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // End Session button
                        TextButton(
                          onPressed: () => _showEndDialog(context, state.ambience.title),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: const Text(
                            'End Session',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is PlayerError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Ready to start?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEndDialog(BuildContext context, String ambienceTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'End Session?',
          style: TextStyle(
            color: Color(0xFF1E2B3A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to end this session?',
          style: TextStyle(
            color: Color(0xFF5A6B7A),
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // End the session
              context.read<PlayerBloc>().add(const EndSession());
              // Navigate to reflection with the title
              Navigator.pushReplacementNamed(
                context,
                '/reflection',
                arguments: ambienceTitle,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('End'),
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

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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