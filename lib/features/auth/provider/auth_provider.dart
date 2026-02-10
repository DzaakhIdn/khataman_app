import 'package:flutter/material.dart';
import 'package:khataman_app/features/profiles/profile_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod/riverpod.dart';
import 'package:toastification/toastification.dart';
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

      // Show success toast
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        title: Text("Akun berhasil dibuat!"),
        description: Text("Selamat datang teman ku☺️"),
        alignment: Alignment.topRight,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(12.0),
        dragToClose: true,
        showIcon: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      // Show error toast
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: Text("terjadi kesalahan"),
        description: Text(_getErrorMessage(e.toString())),
        alignment: Alignment.topRight,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(12.0),
        dragToClose: true,
        showIcon: false,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.login(email: email, password: password);
      final user = _repository.getCurrentUser();

      state = state.copyWith(isLoading: false, userId: user?.id);

      // Show success toast
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        title: Text("Login berhasil!"),
        description: Text("Selamat datang kembali☺️"),
        alignment: Alignment.topRight,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(12.0),
        dragToClose: true,
        showIcon: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      // Show error toast
      toastification.show(
        title: const Text('Login Failed'),
        description: Text(_getErrorMessage(e.toString())),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'password atau email salah';
    } else if (error.contains('User already registered')) {
      return 'Email udah terdaftar!, coba pake email lain';
    } else if (error.contains('Password should be at least 6 characters')) {
      return 'password harus lebih panjang';
    } else if (error.contains('Unable to validate email address')) {
      return 'tolong masukan email yang bener';
    } else if (error.contains('Network request failed')) {
      return 'Kesalahan jaringan, cek koneksi mu!';
    } else if (error.contains('Email not confirmed')) {
      return 'Please check your email and confirm your account.';
    } else if (error.contains('Failed to create profile')) {
      return 'Akun berhasil dibuat tapi gagal :v';
    } else if (error.contains('duplicate key value')) {
      return 'Akun nya udah ada!';
    } else if (error.contains('violates foreign key constraint')) {
      return 'Database constraint error. Please try again.';
    } else {
      return 'Terjadi kesalahan';
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);
