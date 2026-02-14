import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/style/icon_sets.dart';
import 'package:khataman_app/features/home/providers/home_controller.dart';
import 'package:khataman_app/features/home/providers/home_provider.dart';
import 'package:khataman_app/features/target/provider/target_providers.dart';

class HomePage extends ConsumerWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(homeControllerProvider);
    final hijriDate = Hijriyah.now();

    // Cek apakah sedang bulan Ramadan (bulan ke-9)
    final isRamadan = hijriDate.hMonth.toInt() == 9;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: statsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (stats) {
          final targetRepo = ref.watch(targetRepositoryProvider);

          return FutureBuilder(
            future: targetRepo.getActiveTarget(),
            builder: (context, targetSnapshot) {
              if (!targetSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final targetId = targetSnapshot.data!.id;
              final todayPagesAsync = ref.watch(todayPagesProvider(targetId));
              final totalJuzAsync = ref.watch(totalJuzProvider(targetId));

              final ramadanDay = hijriDate.hDay.toInt();
              final progressPercent = (stats.progress * 100).toInt();

              // Hitung hari ke Ramadan atau sisa hari Ramadan
              int daysInfo;
              String daysLabel;

              if (isRamadan) {
                daysInfo = 30 - ramadanDay;
                daysLabel = '$daysInfo DAYS REMAINING';
              } else {
                // Hitung hari sampai Ramadan berikutnya (estimasi)
                final ramadanMonth = 9;
                final currentMonth = hijriDate.hMonth.toInt();
                final currentDay = hijriDate.hDay.toInt();

                if (currentMonth < ramadanMonth) {
                  // Ramadan tahun ini
                  daysInfo = ((ramadanMonth - currentMonth) * 30) - currentDay;
                } else {
                  // Ramadan tahun depan
                  daysInfo =
                      ((12 - currentMonth + ramadanMonth) * 30) - currentDay;
                }
                daysLabel = '$daysInfo DAYS UNTIL RAMADAN';
              }

              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header - Ramadan Day atau Before Ramadan
                        Text(
                          isRamadan
                              ? 'Ramadan Day $ramadanDay'
                              : 'Before Ramadan',
                          style: GoogleFonts.raleway(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Days Info
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Iconify(
                                calendarIcon,
                                size: 16,
                                color: AppColors.light.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                daysLabel,
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Circular Progress
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background circle
                              Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE8F5E9),
                                ),
                              ),

                              // Progress indicator
                              SizedBox(
                                width: 260,
                                height: 260,
                                child: CircularProgressIndicator(
                                  value: stats.progress,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF10B981),
                                  ),
                                ),
                              ),

                              // Center content
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$progressPercent%',
                                    style: GoogleFonts.raleway(
                                      fontSize: 56,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'COMPLETED',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  totalJuzAsync.when(
                                    data: (juzRead) => Text(
                                      '${juzRead.toStringAsFixed(1)} Juz read',
                                      style: GoogleFonts.raleway(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    loading: () => Text(
                                      'Loading...',
                                      style: GoogleFonts.raleway(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    error: (_, __) => Text(
                                      '0 Juz read',
                                      style: GoogleFonts.raleway(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Stats Cards
                        Row(
                          children: [
                            // Streak Card
                            Expanded(
                              child: Container(
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
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFEBEE),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Iconify(
                                            fireIcon,
                                            size: 20,
                                            color: Colors.deepOrangeAccent,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'STREAK',
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black45,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${stats.streak} Days',
                                      style: GoogleFonts.raleway(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Keep it up!',
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Pages Card
                            Expanded(
                              child: Container(
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
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE3F2FD),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Iconify(
                                            pageIcon,
                                            size: 20,
                                            color: Color(0xFF2196F3),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'PAGES',
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black45,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '${stats.totalPagesRead}',
                                      style: GoogleFonts.raleway(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    todayPagesAsync.when(
                                      data: (todayPages) => Text(
                                        todayPages > 0
                                            ? '+$todayPages today'
                                            : 'No pages today',
                                        style: GoogleFonts.raleway(
                                          fontSize: 12,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      loading: () => Text(
                                        'Loading...',
                                        style: GoogleFonts.raleway(
                                          fontSize: 12,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      error: (_, __) => Text(
                                        '',
                                        style: GoogleFonts.raleway(
                                          fontSize: 12,
                                          color: Colors.black38,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Start Reading Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push('/timer');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.menu_book, size: 24),
                            label: Text(
                              'Start Reading Session',
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
