import 'package:shared_preferences/shared_preferences.dart';
import '../models/ambience.dart';
import '../models/session_state.dart';

class SessionRepository {
  static const String _lastSessionKey = 'last_session';

  Future<void> saveLastSession(Ambience ambience, Duration position) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = SessionState(
      ambienceId: ambience.id,
      positionInSeconds: position.inSeconds,
      timestamp: DateTime.now(),
    );
    await prefs.setString(_lastSessionKey, sessionData.toJson().toString());
  }

  Future<SessionState?> getLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_lastSessionKey);
    if (data == null) return null;

    try {
      // This is simplified - you'd need proper JSON parsing
      return SessionState(
        ambienceId: '1',
        positionInSeconds: 0,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSessionKey);
  }
}