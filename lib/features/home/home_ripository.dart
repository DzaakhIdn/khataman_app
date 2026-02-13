import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepository {
  final SupabaseClient _client;

  HomeRepository(this._client);

  Future<int> getTotalPagesRead(String targetId) async {
    final user = _client.auth.currentUser;
    if (user == null) return 0;

    final data = await _client
        .from('reading_sessions')
        .select('pages_read')
        .eq('user_id', user.id)
        .eq('target_id', targetId);

    if (data.isEmpty) return 0;

    int total = 0;
    for (var item in data) {
      total += item['pages_read'] as int;
    }

    return total;
  }

  Future<int> getStreak(String targetId) async {
    final user = _client.auth.currentUser;
    if (user == null) return 0;

    final data = await _client
        .from('reading_sessions')
        .select('session_date')
        .eq('user_id', user.id)
        .eq('target_id', targetId)
        .order('session_date', ascending: false);

    if (data.isEmpty) return 0;

    int streak = 0;
    DateTime today = DateTime.now();

    for (var item in data) {
      DateTime date = DateTime.parse(item['session_date']);
      int diff = today.difference(date).inDays;

      if (diff == streak) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Future<int> getTodayPagesRead(String targetId) async {
    final user = _client.auth.currentUser;
    if (user == null) return 0;

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final data = await _client
        .from('reading_sessions')
        .select('pages_read')
        .eq('user_id', user.id)
        .eq('target_id', targetId)
        .eq('session_date', todayStr)
        .maybeSingle();

    if (data == null) return 0;

    return data['pages_read'] as int;
  }
}
