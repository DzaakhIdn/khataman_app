import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(Supabase.instance.client);
});

final readingHistoryProvider =
    FutureProvider.family<Map<String, List<Map<String, dynamic>>>, String>((
      ref,
      targetId,
    ) async {
      final repo = ref.read(historyRepositoryProvider);
      return repo.getReadingHistory(targetId);
    });
