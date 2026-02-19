import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryRepository {
  final SupabaseClient _client;

  HistoryRepository(this._client);

  Future<Map<String, List<Map<String, dynamic>>>> getReadingHistory(
    String targetId,
  ) async {
    final user = _client.auth.currentUser;
    if (user == null) return {};

    final data = await _client
        .from('reading_sessions')
        .select('*')
        .eq('user_id', user.id)
        .eq('target_id', targetId)
        .order('session_date', ascending: false);

    // Group by date
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var session in data) {
      final date = session['session_date'] as String;
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(session);
    }

    return groupedData;
  }
}
