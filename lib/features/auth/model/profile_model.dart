class AppProfile {
  final String? username;
  final String? avatar;
  final num? targetKhatam;
  final num? totalJuzTarget;
  final int? startDate;

  AppProfile({
    this.username,
    this.avatar,
    this.targetKhatam,
    this.startDate,
    this.totalJuzTarget,
  });

  factory AppProfile.fromSupabase(dynamic profiles) {
    return AppProfile(
      username: profiles.username,
      avatar: profiles.avatar_url,
      targetKhatam: profiles.target_khatam,
      totalJuzTarget: profiles.total_juz_target,
      startDate: profiles.start_ramadhan,
    );
  }
}
