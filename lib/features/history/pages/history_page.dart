import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/features/history/providers/history_provider.dart';
import 'package:khataman_app/features/history/widgets/history_card.dart';
import 'package:khataman_app/features/target/provider/target_providers.dart';

class HistoryPage extends ConsumerWidget {
  static const routeName = '/history';

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetRepo = ref.watch(targetRepositoryProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: FutureBuilder(
        future: targetRepo.getActiveTarget(),
        builder: (context, targetSnapshot) {
          if (targetSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (targetSnapshot.hasError || !targetSnapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.black38),
                  const SizedBox(height: 16),
                  Text(
                    'No active target found',
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }

          final targetId = targetSnapshot.data!.id;
          final historyAsync = ref.watch(readingHistoryProvider(targetId));

          return historyAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.black38),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading history',
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            data: (historyData) {
              if (historyData.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.black38),
                      const SizedBox(height: 16),
                      Text(
                        'No reading history yet',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start a reading session to see your progress',
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Sort dates descending
              final sortedDates = historyData.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "History Page" text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 100, 24, 16),
                    child: Text(
                      'History Page',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 2, 65, 43),
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  // List of history cards
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      itemCount: sortedDates.length,
                      itemBuilder: (context, index) {
                        final date = sortedDates[index];
                        final sessions = historyData[date]!;
                        final dayNumber = sortedDates.length - index;

                        return HistoryCard(
                          date: date,
                          sessions: sessions,
                          dayNumber: dayNumber,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
