import 'package:khataman_app/features/timer/models/timer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReadingSessionRepository {
  final SupabaseClient supabase;

  ReadingSessionRepository(this.supabase);

  Future<void> insertSession(ReadingSessionModel session) async {
    await supabase.from('reading_sessions').insert(session.toJson());
  }

  Future<double> getTotalPagesRead(String userId) async {
    final res = await supabase
        .from('reading_sessions')
        .select('pages_read')
        .eq('user_id', userId);

    double total = 0;
    for (var item in res) {
      total += (item['pages_read'] ?? 0);
    }

    return total;
  }
}
