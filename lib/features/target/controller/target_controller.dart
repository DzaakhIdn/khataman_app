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

  Future<void> saveTarget(
    int totalKhatam,
    int totalHalaman,
    int ramadhanYear,
  ) async {
    state = const AsyncLoading();
    try {
      print('🔄 Controller: Saving target...');
      await _repo.createTarget(
        totalKhatam: totalKhatam,
        totalHalaman: totalHalaman,
        ramadhanYear: ramadhanYear,
      );
      print('✅ Controller: Target saved successfully');
      state = const AsyncData(null);
    } catch (e, st) {
      print('❌ Controller: Error saving target: $e');
      print('Stack trace: $st');
      state = AsyncError(e, st);
      rethrow; // Rethrow agar bisa di-catch di UI
    }
  }
}
