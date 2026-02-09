import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  /// Insert profile saat register (username saja)
  Future<void> createProfile({
    required String userId,
    required String username,
  }) async {
    final response = await _client.from('profiles').insert({
      'id': userId,
      'username': username,
    });

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  Future<void> updateTarget({
    required String userId,
    required int targetKhatam,
    required int totalJuzTarget,
    required DateTime startRamadhan,
    String? avatarUrl,
  }) async {
    await _client
        .from('profiles')
        .update({
          'target_khatam': targetKhatam,
          'total_juz_target': totalJuzTarget,
          'start_ramadhan': startRamadhan.toIso8601String(),
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        })
        .eq('id', userId);
  }
}
