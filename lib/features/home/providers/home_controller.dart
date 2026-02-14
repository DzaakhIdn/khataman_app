import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/features/home/models/home_models.dart';
import 'package:khataman_app/features/home/providers/home_provider.dart';
import 'package:khataman_app/features/target/provider/target_providers.dart';

final homeControllerProvider = FutureProvider<HomeStats>((ref) async {
  final homeRepo = ref.read(homeRepositoryProvider);
  final targetRepo = ref.read(targetRepositoryProvider);

  final activeTarget = await targetRepo.getActiveTarget();

  final totalTargetPages = activeTarget.totalKhatam * 604;

  final totalRead = await homeRepo.getTotalPagesRead(activeTarget.id);

  final streak = await homeRepo.getStreak(activeTarget.id);

  final progress = totalRead.toDouble() / totalTargetPages.toDouble();

  return HomeStats(
    totalPagesRead: totalRead,
    totalPagesTarget: totalTargetPages,
    progress: progress,
    streak: streak,
  );
});
