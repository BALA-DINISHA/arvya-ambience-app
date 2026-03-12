import 'package:arvya_ambience_app/features/ambience/widgets/filter_clips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ambience_bloc.dart';
import '../bloc/ambience_event.dart';
import '../bloc/ambience_state.dart';
import '../widgets/ambience_card.dart';
import '../widgets/search_bar.dart';
import '../../player/bloc/player_bloc.dart';
import '../../player/bloc/player_states.dart';
import '../../player/view/mini_player.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AmbienceBloc>().add( LoadAmbiences());
    });

    return Scaffold(
      // In HomeScreen appBar action
      backgroundColor: const Color(0xFFF8F9FA),
        // In the AppBar, add a history icon
        appBar: AppBar(
          title: const Text(
            'ArvyaX Ambiences',
            style: TextStyle(
              color: Color(0xFF1E2B3A),
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Color(0xFF1E2B3A)),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
          ],
        ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                CustomSearchBar(
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      context.read<AmbienceBloc>().add(
                        FilterAmbiences(searchQuery: query),
                      );
                    } else {
                      context.read<AmbienceBloc>().add(
                        const FilterAmbiences(searchQuery: ''),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                FilterChips(
                  onTagSelected: (tag) {
                    context.read<AmbienceBloc>().add(
                      FilterAmbiences(selectedTag: tag),
                    );
                  },
                ),
              ],
            ),
          ),

          // Ambiences List
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FA),
              child: BlocBuilder<AmbienceBloc, AmbienceState>(
                builder: (context, state) {
                  print('Current state: $state'); // Debug print

                  if (state is AmbienceLoading) {
                    return const LoadingIndicator();
                  }

                  if (state is AmbienceLoaded) {
                    print('Loaded ${state.filteredAmbiences.length} ambiences');

                    if (state.filteredAmbiences.isEmpty) {
                      return EmptyState(
                        message: 'No ambiences found',
                        onClearFilters: () {
                          context.read<AmbienceBloc>().add(
                            const FilterAmbiences(searchQuery: '', selectedTag: ''),
                          );
                        },
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredAmbiences.length,
                      itemBuilder: (context, index) {
                        final ambience = state.filteredAmbiences[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AmbienceCard(
                            ambience: ambience,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: ambience,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }

                  if (state is AmbienceError) {
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
                              context.read<AmbienceBloc>().add(LoadAmbiences());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Initial state
                  return const Center(
                    child: Text('Tap to load ambiences'),
                  );
                },
              ),
            ),
          ),

          // Mini Player (if active)
          BlocBuilder<PlayerBloc, PlayerBlocState>(
            builder: (context, state) {
              if (state is PlayerActive) {
                return const MiniPlayer();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}