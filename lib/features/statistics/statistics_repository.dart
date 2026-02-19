import 'package:supabase_flutter/supabase_flutter.dart';

class StatisticsRepository {
  final SupabaseClient _supabase;

  StatisticsRepository(this._supabase);

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get active target
      final targetResponse = await _supabase
          .from('targets')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .single();

      print('Target Response: $targetResponse');

      final targetId = targetResponse['id'];
      final totalKhatam = targetResponse['total_khatam'] ?? 1;
      final totalJuz = totalKhatam * 30;

      print('Total Khatam from DB: $totalKhatam');
      print('Total Juz: $totalJuz');

      // Get all reading sessions for this target
      final sessionsResponse = await _supabase
          .from('reading_sessions')
          .select()
          .eq('target_id', targetId)
          .order('session_date', ascending: true);

      final sessions = sessionsResponse as List<dynamic>;

      // Calculate total juz completed
      double totalJuzCompleted = 0;
      int totalDuration = 0;
      int totalPages = 0;
      Map<DateTime, int> heatmapData = {};
      List<int> juzProgress = List.filled(
        30,
        0,
      ); // 0: later, 1: reading, 2: done

      for (var session in sessions) {
        // Duration
        final duration = session['duration_minutes'];
        if (duration != null) {
          totalDuration += duration is int
              ? duration
              : (duration as double).toInt();
        }

        // Pages
        final pages = session['pages_read'];
        if (pages != null) {
          totalPages += pages is int ? pages : (pages as double).toInt();
        }

        // Juz calculation
        final juzFrom = session['juz_from'];
        final juzTo = session['juz_to'];

        if (juzFrom != null && juzTo != null) {
          double from = juzFrom is int ? juzFrom.toDouble() : juzFrom as double;
          double to = juzTo is int ? juzTo.toDouble() : juzTo as double;
          totalJuzCompleted += (to - from);

          // Update juz progress
          int startJuz = from.floor();
          int endJuz = to.floor();

          for (int i = startJuz; i <= endJuz && i < 30; i++) {
            if (i == endJuz && to % 1 == 0 && to == endJuz.toDouble()) {
              juzProgress[i] = 2; // Done
            } else if (i < endJuz) {
              juzProgress[i] = 2; // Done
            } else {
              juzProgress[i] = 1; // Reading
            }
          }
        }

        // Heatmap data
        final sessionDate = DateTime.parse(session['session_date']);
        final dateOnly = DateTime(
          sessionDate.year,
          sessionDate.month,
          sessionDate.day,
        );
        final pagesInt = pages != null
            ? (pages is int ? pages : (pages as double).toInt())
            : 0;
        heatmapData[dateOnly] = (heatmapData[dateOnly] ?? 0) + pagesInt;
      }

      // Calculate progress (per 30 juz = 1 khatam)
      final khatamCompleted = (totalJuzCompleted / 30).floor();
      final currentJuz = totalJuzCompleted % 30;
      final progress = currentJuz / 30; // Progress untuk khatam saat ini

      // Calculate average minutes per session
      final avgMinutes = sessions.isNotEmpty
          ? (totalDuration / sessions.length).round()
          : 0;

      // Calculate hours and minutes
      final totalHours = totalDuration ~/ 60;
      final totalMinutes = totalDuration % 60;

      return {
        'progress': progress > 1.0 ? 1.0 : progress,
        'juzCompleted': currentJuz.toInt(),
        'totalJuz': 30, // Always 30 juz per khatam
        'khatamCompleted': khatamCompleted,
        'totalKhatam': totalKhatam,
        'totalJuzRead': totalJuzCompleted.toInt(),
        'totalHours': totalHours,
        'totalMinutes': totalMinutes,
        'avgMinutes': avgMinutes,
        'totalPages': totalPages,
        'heatmapData': heatmapData,
        'juzProgress': juzProgress,
      };
    } catch (e) {
      print('Error getting statistics: $e');
      rethrow;
    }
  }
}
