import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/features/timer/controller/timer_controller.dart';
import '../widget/end_dialog.dart';
import 'dart:math';

class ReadingSessionPage extends ConsumerStatefulWidget {
  static const routeName = '/timer';
  const ReadingSessionPage({super.key});

  @override
  ConsumerState<ReadingSessionPage> createState() => _ReadingSessionPageState();
}

class _ReadingSessionPageState extends ConsumerState<ReadingSessionPage> {
  int selectedDuration = 15; // Default 15 minutes
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    // Set timer sesuai durasi yang dipilih
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(readingTimerProvider.notifier).setDuration(selectedDuration);
    });
  }

  void _updateDuration(int minutes) {
    setState(() {
      selectedDuration = minutes;
      isRunning = false;
    });
    ref.read(readingTimerProvider.notifier).setDuration(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final seconds = ref.watch(readingTimerProvider);
    final timerController = ref.read(readingTimerProvider.notifier);

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    // Calculate progress (assuming max is selected duration)
    final totalSeconds = selectedDuration * 60;
    final progress = seconds / totalSeconds;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 45),
                // Current Target Section
                Text(
                  'CURRENT TARGET',
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.menu_book,
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
                              'Reading Session',
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Target: ${(selectedDuration / 5).ceil()} pages minimum',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Duration Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDurationChip(15),
                    _buildDurationChip(30),
                    _buildDurationChip(45),
                    _buildDurationChip(60),
                  ],
                ),

                const SizedBox(height: 48),

                // Circular Timer
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
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                      ),

                      // Progress indicator
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: CustomPaint(
                          painter: TimerPainter(
                            progress: progress,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),

                      // Timer text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                            style: GoogleFonts.raleway(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'REMAINING',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reset Button
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8F5E9),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Color(0xFF10B981),
                          size: 28,
                        ),
                        onPressed: () {
                          timerController.reset();
                          setState(() {
                            isRunning = false;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Play/Pause Button
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF10B981),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          if (isRunning) {
                            timerController.stop();
                          } else {
                            timerController.start();
                          }
                          setState(() {
                            isRunning = !isRunning;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Complete Button
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE8F5E9),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Color(0xFF10B981),
                          size: 28,
                        ),
                        onPressed: () {
                          timerController.stop();
                          showEndSessionDialog(context, ref);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationChip(int minutes) {
    final isSelected = selectedDuration == minutes;

    return GestureDetector(
      onTap: () {
        _updateDuration(minutes);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Color(0xFF10B981).withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          '$minutes min',
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black45,
          ),
        ),
      ),
    );
  }
}

// Custom Painter for circular progress
class TimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  TimerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
