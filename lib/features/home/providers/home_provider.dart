import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home_ripository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.read(supabaseClientProvider));
});

final hasTargetProvider = FutureProvider<bool>((ref) async {
  final client = ref.read(supabaseClientProvider);
  final user = client.auth.currentUser;

  if (user == null) return false;

  final data = await client
      .from('targets')
      .select('id')
      .eq('user_id', user.id)
      .eq('is_active', true)
      .maybeSingle();

  return data != null;
});

// Provider untuk get streak dengan targetId
final streakProvider = FutureProvider.family<int, String>((
  ref,
  targetId,
) async {
  final repo = ref.read(homeRepositoryProvider);
  return repo.getStreak(targetId);
});

// Provider untuk get total pages read dengan targetId
final totalPagesProvider = FutureProvider.family<int, String>((
  ref,
  targetId,
) async {
  final repo = ref.read(homeRepositoryProvider);
  return repo.getTotalPagesRead(targetId);
});

// Provider untuk get pages read hari ini
final todayPagesProvider = FutureProvider.family<int, String>((
  ref,
  targetId,
) async {
  final repo = ref.read(homeRepositoryProvider);
  return repo.getTodayPagesRead(targetId);
});
