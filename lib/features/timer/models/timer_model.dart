class ReadingSessionModel {
  final String id;
  final String userId;
  final DateTime sessionDate;
  final int durationMinutes;
  final double? juzFrom;
  final double? juzTo;
  final double? pagesRead;
  final String? targetId;

  ReadingSessionModel({
    required this.id,
    required this.userId,
    required this.sessionDate,
    required this.durationMinutes,
    this.juzFrom,
    this.juzTo,
    this.pagesRead,
    this.targetId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'session_date': sessionDate.toIso8601String(),
      'duration_minutes': durationMinutes,
      'juz_from': juzFrom,
      'juz_to': juzTo,
      'pages_read': pagesRead,
      'target_id': targetId,
    };
  }
}
