import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:khataman_app/features/target/provider/target_providers.dart';
import 'package:khataman_app/features/target/target_repository.dart';

final targetControllerProvider =
    StateNotifierProvider<TargetController, AsyncValue<void>>(
      (ref) => TargetController(ref.read(targetRepositoryProvider)),
    );

class TargetController extends StateNotifier<AsyncValue<void>> {
  final TargetRepository _repo;

  TargetController(this._repo) : super(const AsyncData(null));

  Future<void> saveTarget(int totalKhatam, int totalHalaman) async {
    state = const AsyncLoading();
    try {
      await _repo.createTarget(
        totalKhatam: totalKhatam,
        totalHalaman: totalHalaman,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
