class AppUser {
  final String id;
  final String email;

  AppUser({required this.id, required this.email});

  factory AppUser.fromSupabase(dynamic user) {
    return AppUser(id: user.id, email: user.email ?? '');
  }
}
