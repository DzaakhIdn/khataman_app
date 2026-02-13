class TargetModel {
  final String id;
  final String userId;
  final int totalKhatam;
  final int totalHalaman;
  final int ramadhanYear;
  final bool isActive;
  final DateTime createdAt;

  TargetModel({
    required this.id,
    required this.userId,
    required this.totalKhatam,
    required this.totalHalaman,
    required this.ramadhanYear,
    required this.isActive,
    required this.createdAt,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      totalKhatam: json['total_khatam'] as int,
      totalHalaman: json['total_halaman'] as int,
      ramadhanYear: json['ramadhan_year'] as int,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
