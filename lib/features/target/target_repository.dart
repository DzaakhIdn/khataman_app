import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/target_model.dart';

class TargetRepository {
  final SupabaseClient _client;

  TargetRepository(this._client);

  Future<void> createTarget({
    required int totalKhatam,
    required int totalHalaman,
    required int ramadhanYear,
  }) async {
    try {
      final user = _client.auth.currentUser;

      print('🔄 Creating target...');
      print('User ID: ${user?.id}');
      print('Total Khatam: $totalKhatam');
      print('Total Halaman: $totalHalaman');

      if (user == null) {
        throw Exception('User belum login');
      }

      final response = await _client.from('targets').insert({
        'user_id': user.id,
        'total_khatam': totalKhatam,
        'total_halaman': totalHalaman,
        'ramadhan_year': ramadhanYear,
        'is_active': true,
      }).select();

      print('✅ Target created successfully');
      print('Response: $response');
    } catch (e) {
      print('❌ Error creating target: $e');
      rethrow;
    }
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

  Future<TargetModel> getActiveTarget() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    final data = await _client
        .from('targets')
        .select()
        .eq('user_id', user.id)
        .eq('is_active', true)
        .maybeSingle();

    if (data == null) {
      throw Exception('Tidak ada target aktif');
    }

    return TargetModel.fromJson(data);
  }
}
