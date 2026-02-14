import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/features/timer/controller/timer_controller.dart';
import 'package:khataman_app/features/timer/models/timer_model.dart';
import 'package:khataman_app/features/timer/timer_repository.dart';
import 'package:khataman_app/features/home/providers/home_controller.dart';
import 'package:khataman_app/features/home/providers/home_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

void showEndSessionDialog(BuildContext context, WidgetRef ref) {
  final pagesController = TextEditingController();
  final juzFromController = TextEditingController();
  final juzToController = TextEditingController();

  // State untuk tracking last valid position
  double currentJuzPosition = 0.0;

  void calculateJuzFromPages() {
    final pages = int.tryParse(pagesController.text);
    if (pages == null || pages <= 0) return;

    // 1 juz = 20 halaman
    final juzRead = pages / 20.0;

    // Set juz_from ke posisi terakhir
    juzFromController.text = currentJuzPosition.toStringAsFixed(2);

    // Set juz_to = juz_from + juz yang dibaca
    final newPosition = currentJuzPosition + juzRead;
    juzToController.text = newPosition.toStringAsFixed(2);

    // Update current position untuk session berikutnya
    currentJuzPosition = newPosition;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Session',
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Record your reading progress',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black45),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Pages Read Input
                Text(
                  'Pages Read *',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: pagesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.raleway(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter number of pages (1-604)',
                    hintStyle: GoogleFonts.raleway(color: Colors.black38),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calculate, color: Color(0xFF10B981)),
                      onPressed: () {
                        setState(() {
                          calculateJuzFromPages();
                        });
                      },
                      tooltip: 'Calculate Juz',
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      calculateJuzFromPages();
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Info text
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '1 Juz = 20 pages. Juz will be calculated automatically.',
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Juz Range (Read-only, auto-calculated)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From Juz',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: juzFromController,
                            readOnly: true,
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Auto',
                              hintStyle: GoogleFonts.raleway(
                                color: Colors.black38,
                              ),
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To Juz',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: juzToController,
                            readOnly: true,
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Auto',
                              hintStyle: GoogleFonts.raleway(
                                color: Colors.black38,
                              ),
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validasi
                      final pages = int.tryParse(pagesController.text);
                      if (pages == null || pages <= 0) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text(
                            "Please enter valid number of pages",
                          ),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      if (pages > 604) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text(
                            "Pages cannot exceed 604 (total Quran pages)",
                          ),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      final juzFrom = double.tryParse(juzFromController.text);
                      final juzTo = double.tryParse(juzToController.text);

                      if (juzFrom == null || juzTo == null) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text(
                            "Please enter pages to calculate Juz",
                          ),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      if (juzTo > 30) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text("Juz cannot exceed 30"),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      final user = Supabase.instance.client.auth.currentUser;
                      if (user == null) return;

                      final repo = ReadingSessionRepository(
                        Supabase.instance.client,
                      );

                      // Get active target
                      final targetData = await Supabase.instance.client
                          .from('targets')
                          .select('id')
                          .eq('user_id', user.id)
                          .eq('is_active', true)
                          .maybeSingle();

                      final targetId = targetData?['id'] as String?;

                      final timer = ref.read(readingTimerProvider.notifier);

                      final session = ReadingSessionModel(
                        id: '',
                        userId: user.id,
                        sessionDate: DateTime.now(),
                        durationMinutes: timer.durationMinutes,
                        pagesRead: pages.toDouble(),
                        juzFrom: juzFrom,
                        juzTo: juzTo,
                        targetId: targetId,
                      );

                      await repo.insertSession(session);

                      // Invalidate providers untuk refresh data
                      ref.invalidate(homeControllerProvider);
                      if (targetId != null) {
                        ref.invalidate(todayPagesProvider(targetId));
                        ref.invalidate(streakProvider(targetId));
                        ref.invalidate(totalPagesProvider(targetId));
                        ref.invalidate(totalJuzProvider(targetId));
                      }

                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        style: ToastificationStyle.flatColored,
                        title: Text("Session Saved!"),
                        description: Text(
                          "Your reading progress has been recorded",
                        ),
                        alignment: Alignment.topRight,
                        autoCloseDuration: const Duration(seconds: 3),
                        borderRadius: BorderRadius.circular(12.0),
                      );

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Session',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
