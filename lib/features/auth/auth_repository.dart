import 'package:supabase_flutter/supabase_flutter.dart';
import '../profiles/profile_repository.dart';

class AuthRepository {
  final SupabaseClient _client;
  final ProfileRepository _profileRepository;

  AuthRepository(this._client, this._profileRepository);

  Future<String> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final authResponse = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = authResponse.user;
    if (user == null) {
      throw Exception('Register gagal');
    }

    // Insert profile (username only)
    await _profileRepository.createProfile(userId: user.id, username: username);

    return user.id;
  }

  Future<void> login({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
