import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:toastification/toastification.dart';
import 'package:khataman_app/features/target/controller/target_controller.dart';
import 'package:toastification/toastification.dart';

class TargetPages extends ConsumerStatefulWidget {
  static const routeName = '/target';
  const TargetPages({super.key});

  @override
  ConsumerState<TargetPages> createState() => _TargetPagesState();
}

class _TargetPagesState extends ConsumerState<TargetPages> {
  int selectedTarget = 1;
  final TextEditingController _customController = TextEditingController();
  bool isCustom = false;

  final int ramadhanDays = 30;
  final int totalHalaman = 604;

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  double calculateJuzPerDay(int targetKhatam) {
    return ((totalHalaman * targetKhatam) / ramadhanDays).ceilToDouble();
  }

  String formatHalamanPerDay(double halPerDay) {
    return '${halPerDay.toInt()} halaman per day';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(targetControllerProvider);

    ref.listen(targetControllerProvider, (prev, next) {
      if (next is AsyncData) {
        context.goNamed('/home');
      }
    });
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.light.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 50,
                  color: AppColors.light.primary,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'How many times do\nyou want to complete\nthe Quran?',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Set an achievable target for this holy month.',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // Target Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // One Time
                      _buildTargetOption(
                        number: 1,
                        title: 'One Time',
                        juzPerDay: calculateJuzPerDay(1),
                        isSelected: selectedTarget == 1 && !isCustom,
                        onTap: () {
                          setState(() {
                            selectedTarget = 1;
                            isCustom = false;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Two Times
                      _buildTargetOption(
                        number: 2,
                        title: 'Two Times',
                        juzPerDay: calculateJuzPerDay(2),
                        isSelected: selectedTarget == 2 && !isCustom,
                        onTap: () {
                          setState(() {
                            selectedTarget = 2;
                            isCustom = false;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Three Times
                      _buildTargetOption(
                        number: 3,
                        title: 'Three Times',
                        juzPerDay: calculateJuzPerDay(3),
                        isSelected: selectedTarget == 3 && !isCustom,
                        onTap: () {
                          setState(() {
                            selectedTarget = 3;
                            isCustom = false;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Custom Target
                      _buildCustomTargetOption(),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          _saveTarget();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.light.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: state.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Info text
              Text(
                'You can change this goal later in settings',
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetOption({
    required int number,
    required String title,
    required double juzPerDay,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.light.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.light.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Number Badge
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.light.primary.withOpacity(0.2)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.light.primary
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatHalamanPerDay(juzPerDay),
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.light.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.light.primary
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTargetOption() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCustom ? AppColors.light.primary : Colors.grey[300]!,
          width: isCustom ? 2 : 1,
        ),
        boxShadow: isCustom
            ? [
                BoxShadow(
                  color: AppColors.light.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Custom Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCustom
                      ? AppColors.light.primary.withOpacity(0.2)
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 24,
                  color: isCustom ? AppColors.light.primary : Colors.grey[600],
                ),
              ),

              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  'Custom Target',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              // Checkmark
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCustom
                      ? AppColors.light.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: isCustom
                        ? AppColors.light.primary
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isCustom
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Custom Input
          TextField(
            controller: _customController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.raleway(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter number of times',
              hintStyle: GoogleFonts.raleway(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.light.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isCustom = true;
                  selectedTarget = int.tryParse(value) ?? 1;
                });
              } else {
                setState(() {
                  isCustom = false;
                  selectedTarget = 1;
                });
              }
            },
          ),

          if (isCustom && _customController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              formatHalamanPerDay(calculateJuzPerDay(selectedTarget)),
              style: GoogleFonts.raleway(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  void _saveTarget() async {
    final targetKhatam = isCustom
        ? (int.tryParse(_customController.text) ?? 1)
        : selectedTarget;

    final halamanPerDay = calculateJuzPerDay(targetKhatam);
    final totalHalamanTarget = totalHalaman * targetKhatam;

    debugPrint('Target Khatam: $targetKhatam');
    debugPrint('Halaman per day: $halamanPerDay');
    debugPrint('Total Halaman Target: $totalHalamanTarget');

    try {
      await ref
          .read(targetControllerProvider.notifier)
          .saveTarget(targetKhatam, totalHalamanTarget.toInt());

      // Show success toast
      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text("Target Set!"),
          description: Text(
            "Your goal is to read $halamanPerDay halaman per day",
          ),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(12.0),
        );

        // Navigate to home after success
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.go('/home');
          }
        });
      }
    } catch (e) {
      // Show error toast
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: const Text("Error"),
          description: Text(e.toString()),
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(12.0),
          dragToClose: true,
          showIcon: false,
        );
      }
    }
  }
}
