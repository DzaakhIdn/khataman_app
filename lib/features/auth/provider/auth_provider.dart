import 'package:khataman_app/features/profiles/profile_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod/riverpod.dart';
import '../auth_repository.dart';

final supabaseClientProvider = Provider((ref) => Supabase.instance.client);

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.read(supabaseClientProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.read(supabaseClientProvider),
    ref.read(profileRepositoryProvider),
  ),
);

class AuthState {
  final bool isLoading;
  final String? error;
  final String? userId;

  AuthState({this.isLoading = false, this.error, this.userId});

  AuthState copyWith({bool? isLoading, String? error, String? userId}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userId: userId ?? this.userId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState());

  Future<void> register(String email, String password, String username) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = await _repository.register(
        email: email,
        password: password,
        username: username,
      );

      state = state.copyWith(isLoading: false, userId: userId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.login(email: email, password: password);
      final user = _repository.getCurrentUser();

      state = state.copyWith(isLoading: false, userId: user?.id);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);
