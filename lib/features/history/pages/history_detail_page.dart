import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/style/icon_sets.dart';

class HistoryDetailPage extends StatelessWidget {
  static const routeName = '/history-detail';

  final String date;
  final List<Map<String, dynamic>> sessions;
  final int dayNumber;

  const HistoryDetailPage({
    super.key,
    required this.date,
    required this.sessions,
    required this.dayNumber,
  });

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getSessionTime(int index) {
    return 'Sesi ke-${index + 1}';
  }

  String _getTimeRange(String? createdAt, int duration) {
    if (createdAt == null) return '--:-- - --:--';

    try {
      final startTime = DateTime.parse(createdAt);
      final endTime = startTime.add(Duration(minutes: duration));

      final startHour = startTime.hour.toString().padLeft(2, '0');
      final startMinute = startTime.minute.toString().padLeft(2, '0');
      final endHour = endTime.hour.toString().padLeft(2, '0');
      final endMinute = endTime.minute.toString().padLeft(2, '0');

      return '$startHour:$startMinute - $endHour:$endMinute';
    } catch (e) {
      return '--:-- - --:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    final totalSessions = sessions.length;
    int totalDuration = 0;
    int totalPages = 0;
    double juzFrom = double.infinity;
    double juzTo = 0.0;

    for (var session in sessions) {
      final duration = session['duration_minutes'];
      if (duration != null) {
        if (duration is int) {
          totalDuration += duration;
        } else if (duration is double) {
          totalDuration += duration.toInt();
        }
      }

      final pages = session['pages_read'];
      if (pages != null) {
        if (pages is int) {
          totalPages += pages;
        } else if (pages is double) {
          totalPages += pages.toInt();
        }
      }

      final jFrom = session['juz_from'];
      final jTo = session['juz_to'];

      if (jFrom != null) {
        double from = jFrom is int ? jFrom.toDouble() : jFrom as double;
        if (from < juzFrom) juzFrom = from;
      }

      if (jTo != null) {
        double to = jTo is int ? jTo.toDouble() : jTo as double;
        if (to > juzTo) juzTo = to;
      }
    }

    final parsedDate = DateTime.parse(date);
    final juzCompleted = juzFrom == double.infinity ? 0 : (juzTo - juzFrom);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // App Bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Color(0xFF10B981),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        '${parsedDate.day} Ramadan 1445H',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hari ke-$dayNumber',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${parsedDate.day} ${_getMonthName(parsedDate.month)} ${parsedDate.year}',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.access_time,
                          value:
                              '${(totalDuration ~/ 60)}h ${totalDuration % 60}m',
                          label: 'Durasi',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Center(
                            child: Iconify(
                              bookIcon,
                              color: AppColors.light.primary,
                            ),
                          ),
                          value: '$totalPages',
                          label: 'Halaman',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.refresh,
                          value: '${juzCompleted.toStringAsFixed(0)}',
                          label: 'Juz Selesai',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Sessions section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sesi Membaca',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '$totalSessions Sesi',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Session list
                  ...List.generate(
                    sessions.length,
                    (index) => _buildSessionItem(sessions[index], index),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required dynamic icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon is IconData
                ? Icon(icon, color: Color(0xFF10B981), size: 20)
                : icon,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.raleway(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(Map<String, dynamic> session, int index) {
    final duration = session['duration_minutes'];
    int durationInt = 0;
    if (duration != null) {
      if (duration is int) {
        durationInt = duration;
      } else if (duration is double) {
        durationInt = duration.toInt();
      }
    }

    final juzFrom = session['juz_from'];
    final juzTo = session['juz_to'];

    double jFromDouble = 0;
    double jToDouble = 0;

    if (juzFrom != null) {
      jFromDouble = juzFrom is int ? juzFrom.toDouble() : juzFrom as double;
    }
    if (juzTo != null) {
      jToDouble = juzTo is int ? juzTo.toDouble() : juzTo as double;
    }

    final pageFrom = (jFromDouble * 20).toInt() + 1;
    final pageTo = (jToDouble * 20).toInt();

    // Extract created_at from session
    final createdAt = session['created_at'] as String?;
    final timeRange = _getTimeRange(createdAt, durationInt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Iconify(
                sessionIcon,
                size: 24,
                color: AppColors.light.primary,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Session info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getSessionTime(index),
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.black45),
                    const SizedBox(width: 4),
                    Text(
                      timeRange,
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Juz ${jFromDouble.toStringAsFixed(0)} • Hal $pageFrom - $pageTo',
                  style: GoogleFonts.raleway(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Duration badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$durationInt min',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
