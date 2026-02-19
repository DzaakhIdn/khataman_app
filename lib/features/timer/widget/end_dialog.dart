import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/features/timer/controller/timer_controller.dart';
import 'package:khataman_app/features/timer/models/timer_model.dart';
import 'package:khataman_app/features/timer/timer_repository.dart';
import 'package:khataman_app/features/home/providers/home_controller.dart';
import 'package:khataman_app/features/home/providers/home_provider.dart';
import 'package:khataman_app/features/history/providers/history_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

void showEndSessionDialog(BuildContext context, WidgetRef ref) {
  final pageFromController = TextEditingController();
  final pageToController = TextEditingController();
  final juzFromController = TextEditingController();
  final juzToController = TextEditingController();

  int totalPages = 0;
  double totalJuz = 0.0;

  void calculateFromPages() {
    final pageFrom = int.tryParse(pageFromController.text);
    final pageTo = int.tryParse(pageToController.text);

    if (pageFrom == null || pageTo == null) return;
    if (pageFrom > pageTo) return;

    // Hitung total halaman
    totalPages = pageTo - pageFrom + 1;

    // Hitung juz (1 juz = 20 halaman)
    // pageFrom menentukan juz_from
    final juzFrom = (pageFrom - 1) / 20.0;
    // pageTo menentukan juz_to
    final juzTo = pageTo / 20.0;

    juzFromController.text = juzFrom.toStringAsFixed(2);
    juzToController.text = juzTo.toStringAsFixed(2);

    totalJuz = juzTo - juzFrom;
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

                // Page Range Input
                Text(
                  'Page Range *',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pageFromController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: GoogleFonts.raleway(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'From page',
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
                        ),
                        onChanged: (value) {
                          setState(() {
                            calculateFromPages();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.arrow_forward, color: Colors.black45),
                    ),
                    Expanded(
                      child: TextField(
                        controller: pageToController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: GoogleFonts.raleway(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'To page',
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
                        ),
                        onChanged: (value) {
                          setState(() {
                            calculateFromPages();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Summary Info
                if (totalPages > 0)
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
                            'Total: $totalPages pages • ${totalJuz.toStringAsFixed(2)} Juz',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Juz Range (Read-only, auto-calculated)
                Text(
                  'Juz Range (Auto-calculated)',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: juzFromController,
                        readOnly: true,
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                        decoration: InputDecoration(
                          hintText: 'From Juz',
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.arrow_forward, color: Colors.black45),
                    ),
                    Expanded(
                      child: TextField(
                        controller: juzToController,
                        readOnly: true,
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                        decoration: InputDecoration(
                          hintText: 'To Juz',
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
                        ),
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
                      final pageFrom = int.tryParse(pageFromController.text);
                      final pageTo = int.tryParse(pageToController.text);

                      if (pageFrom == null || pageTo == null) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text("Please enter valid page numbers"),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      if (pageFrom < 1 || pageTo < 1) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text("Page numbers must be at least 1"),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      if (pageFrom > pageTo) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text(
                            "'From page' must be less than or equal to 'To page'",
                          ),
                          alignment: Alignment.topRight,
                          autoCloseDuration: const Duration(seconds: 3),
                          borderRadius: BorderRadius.circular(12.0),
                        );
                        return;
                      }

                      if (pageTo > 604) {
                        toastification.show(
                          context: context,
                          type: ToastificationType.error,
                          style: ToastificationStyle.flatColored,
                          title: Text("Invalid Input"),
                          description: Text(
                            "Page cannot exceed 604 (total Quran pages)",
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
                          title: Text("Calculation Error"),
                          description: Text("Please check your page range"),
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
                        pagesRead: totalPages.toDouble(),
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
                        ref.invalidate(readingHistoryProvider(targetId));
                      }

                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        style: ToastificationStyle.flatColored,
                        title: Text("Session Saved!"),
                        description: Text(
                          "$totalPages pages • ${totalJuz.toStringAsFixed(2)} Juz recorded",
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
