import 'package:arvya_ambience_app/core/themes/app_themes.dart';
import 'package:arvya_ambience_app/data/repository/ambience_repository.dart';
import 'package:arvya_ambience_app/data/repository/journal_repository.dart';
import 'package:arvya_ambience_app/data/repository/session_repository.dart';
import 'package:arvya_ambience_app/features/ambience/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';

import 'data/models/ambience.dart';
import 'features/ambience/bloc/ambience_bloc.dart';
import 'features/ambience/bloc/ambience_event.dart';
import 'features/ambience/view/details_screen.dart';
import 'features/journal/view/entry_detail_screen.dart';
import 'features/journal/view/history_screen.dart';
import 'features/journal/view/reflection_screen.dart';
import 'features/player/bloc/player_bloc.dart';
import 'features/journal/bloc/journal_bloc.dart';
import 'features/player/view/session_player.dart';


final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<AmbienceRepository>(AmbienceRepository());
  getIt.registerSingleton<JournalRepository>(JournalRepository());
  getIt.registerSingleton<SessionRepository>(SessionRepository());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Setup dependencies
  setupDependencies();

  // Initialize repositories that need async setup
  await getIt<JournalRepository>().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AmbienceBloc(
            repository: getIt<AmbienceRepository>(),
          )..add(LoadAmbiences()),
        ),
        BlocProvider(
          create: (context) => JournalBloc(
            repository: getIt<JournalRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => PlayerBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ArvyaX',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/details': (context) {
            final ambience =
            ModalRoute.of(context)!.settings.arguments as Ambience;
            return DetailsScreen(ambience: ambience);
          },
          '/player': (context) => const SessionPlayer(),
          '/reflection': (context) => const ReflectionScreen(),
          '/history': (context) => const HistoryScreen(),
          '/entry-detail': (context) => const EntryDetailScreen(),
        },
      ),
    );
  }
}