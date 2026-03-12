class SessionState {
  final String ambienceId;
  final int positionInSeconds;
  final DateTime timestamp;

  SessionState({
    required this.ambienceId,
    required this.positionInSeconds,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'ambienceId': ambienceId,
    'position': positionInSeconds,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SessionState.fromJson(Map<String, dynamic> json) {
    return SessionState(
      ambienceId: json['ambienceId'],
      positionInSeconds: json['position'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}