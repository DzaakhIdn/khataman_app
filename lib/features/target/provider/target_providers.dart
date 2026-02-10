import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/features/target/target_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final targetRepositoryProvider = Provider<TargetRepository>((ref) {
  return TargetRepository(ref.read(supabaseClientProvider));
});

final hasTargetProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(targetRepositoryProvider);
  return repo.hasTarget();
});
