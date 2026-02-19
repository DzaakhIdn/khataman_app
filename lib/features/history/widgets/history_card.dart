import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:khataman_app/core/style/icon_sets.dart';
import 'package:khataman_app/features/history/pages/history_detail_page.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final List<Map<String, dynamic>> sessions;
  final int dayNumber;

  const HistoryCard({
    super.key,
    required this.date,
    required this.sessions,
    required this.dayNumber,
  });

  String _getMonthName(int month) {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    final totalSessions = sessions.length;
    int totalDuration = 0;
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

    // Format date
    final parsedDate = DateTime.parse(date);
    final now = DateTime.now();
    final yesterday = DateTime.now().subtract(Duration(days: 1));

    String dateLabel;
    if (parsedDate.year == now.year &&
        parsedDate.month == now.month &&
        parsedDate.day == now.day) {
      dateLabel = 'TODAY';
    } else if (parsedDate.year == yesterday.year &&
        parsedDate.month == yesterday.month &&
        parsedDate.day == yesterday.day) {
      dateLabel = 'YESTERDAY';
    } else {
      dateLabel = '${_getMonthName(parsedDate.month)} ${parsedDate.day}';
    }

    final juzProgress = juzFrom == double.infinity
        ? 'No data'
        : 'Juz ${juzFrom.toStringAsFixed(0)} → ${juzTo.toStringAsFixed(0)}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryDetailPage(
              date: date,
              sessions: sessions,
              dayNumber: dayNumber,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hari ke-$dayNumber',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  dateLabel,
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats
            _buildStatRow(
              icon: sessionIcon,
              iconColor: Color(0xFF10B981),
              label: 'Total Session',
              value: '$totalSessions sesi',
            ),

            const SizedBox(height: 12),

            _buildStatRow(
              icon: timeIcon,
              iconColor: Color(0xFF3B82F6),
              label: 'Duration',
              value: '$totalDuration menit',
            ),

            const SizedBox(height: 12),

            _buildStatRow(
              icon: bookIcon,
              iconColor: Color(0xFF10B981),
              label: 'Progress',
              value: juzProgress,
              valueColor: Color(0xFF10B981),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required String icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Center(child: Iconify(icon, color: iconColor)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.raleway(fontSize: 14, color: Colors.black54),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
