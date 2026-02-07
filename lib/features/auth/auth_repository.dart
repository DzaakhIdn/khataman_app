import 'package:supabase_flutter/supabase_flutter.dart';
import 'model/user_model.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  AppUser? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AppUser.fromSupabase(user);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login gagal');
    }

    return AppUser.fromSupabase(response.user);
  }

  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('login gagal');
    }

    return AppUser.fromSupabase(response.user);
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
