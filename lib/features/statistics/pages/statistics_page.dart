import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:khataman_app/features/statistics/providers/statistics_provider.dart';

class StatisticsPage extends ConsumerWidget {
  static const routeName = '/statistics';

  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),

              // Ramadan Progress Card
              _buildRamadanProgressCard(stats),

              const SizedBox(height: 24),

              // Reading Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.access_time,
                      iconColor: const Color(0xFFFF9800),
                      value:
                          '${stats['totalHours']}h ${stats['totalMinutes']}m',
                      label: 'Total Time Reading',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.timer_outlined,
                      iconColor: const Color(0xFF2196F3),
                      value: '${stats['avgMinutes']} min',
                      label: 'Avg per Session',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Activity Log Section
              _buildActivityLogSection(stats),

              const SizedBox(height: 32),

              // Juz Breakdown Section
              _buildJuzBreakdownSection(stats),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildRamadanProgressCard(Map<String, dynamic> stats) {
    final progress = stats['progress'] ?? 0.0;
    final juzCompleted = stats['juzCompleted'] ?? 0;
    final totalJuz = stats['totalJuz'] ?? 30;
    final khatamCompleted = stats['khatamCompleted'] ?? 0;
    final totalKhatam = stats['totalKhatam'] ?? 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RAMADAN PROGRESS',
            style: GoogleFonts.raleway(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: GoogleFonts.raleway(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'On Track',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$juzCompleted / $totalJuz Juz Completed',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$khatamCompleted / $totalKhatam Khatam',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              // Circular Progress
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFE8F5E9),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF10B981),
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.menu_book,
                        color: const Color(0xFF10B981),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.raleway(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.raleway(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogSection(Map<String, dynamic> stats) {
    final heatmapData = stats['heatmapData'] as Map<DateTime, int>? ?? {};
    final totalPages = stats['totalPages'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVITY LOG (RAMADAN)',
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Total: $totalPages pages',
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          HeatMap(
            datasets: heatmapData,
            colorMode: ColorMode.color,
            defaultColor: const Color(0xFFE8F5E9),
            textColor: Colors.black87,
            showColorTip: false,
            showText: false,
            scrollable: true,
            size: 40,
            fontSize: 12,
            colorsets: const {
              1: Color(0xFFC7F0DB),
              10: Color(0xFF8FE3BF),
              20: Color(0xFF57D6A3),
              30: Color(0xFF10B981),
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: GoogleFonts.raleway(fontSize: 11, color: Colors.black45),
              ),
              const SizedBox(width: 8),
              _buildLegendBox(const Color(0xFFE8F5E9)),
              const SizedBox(width: 4),
              _buildLegendBox(const Color(0xFFC7F0DB)),
              const SizedBox(width: 4),
              _buildLegendBox(const Color(0xFF8FE3BF)),
              const SizedBox(width: 4),
              _buildLegendBox(const Color(0xFF57D6A3)),
              const SizedBox(width: 4),
              _buildLegendBox(const Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                'More',
                style: GoogleFonts.raleway(fontSize: 11, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildJuzBreakdownSection(Map<String, dynamic> stats) {
    final juzProgress =
        stats['juzProgress'] as List<int>? ?? List.filled(30, 0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Juz Breakdown',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'View Details',
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              final juzNumber = index + 1;
              final status = juzProgress[index];

              return _buildJuzCircle(juzNumber, status);
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildJuzLegend(const Color(0xFF10B981), 'Done'),
              const SizedBox(width: 16),
              _buildJuzLegend(const Color(0xFF8FE3BF), 'Reading'),
              const SizedBox(width: 16),
              _buildJuzLegend(const Color(0xFFE8F5E9), 'Later'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJuzCircle(int number, int status) {
    Color backgroundColor;
    Color textColor;

    if (status == 2) {
      // Done
      backgroundColor = const Color(0xFF10B981);
      textColor = Colors.white;
    } else if (status == 1) {
      // Reading
      backgroundColor = const Color(0xFF8FE3BF);
      textColor = Colors.white;
    } else {
      // Later
      backgroundColor = const Color(0xFFE8F5E9);
      textColor = Colors.black38;
    }

    return Container(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '$number',
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildJuzLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.raleway(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
