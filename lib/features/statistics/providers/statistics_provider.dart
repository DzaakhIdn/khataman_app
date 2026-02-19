import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/features/statistics/statistics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepository(ref.read(supabaseClientProvider));
});

final statisticsControllerProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final repo = ref.read(statisticsRepositoryProvider);
  return await repo.getStatistics();
});
