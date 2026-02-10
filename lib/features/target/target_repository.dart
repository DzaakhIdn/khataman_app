import 'package:supabase_flutter/supabase_flutter.dart';

class TargetRepository {
  final SupabaseClient _client;

  TargetRepository(this._client);

  Future<void> createTarget({required int totalKhatam, required int totalHalaman}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login');

    await _client.from('targets').insert({
      'user_id': user.id,
      'total_khatam': totalKhatam,
      'total_halaman': totalHalaman
    });
  }

  Future<bool> hasTarget() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final data = await _client
        .from('targets')
        .select()
        .eq('user_id', user.id)
        .eq('is_active', true)
        .maybeSingle();

    return data != null;
  }
}
