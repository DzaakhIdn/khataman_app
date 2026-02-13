import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/features/timer/controller/timer_controller.dart';
import '../widget/end_dialog.dart';

class ReadingSessionPage extends ConsumerWidget {
  static const routeName = '/timer';
  const ReadingSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(readingTimerProvider);
    final timerController = ref.read(readingTimerProvider.notifier);

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return Scaffold(
      appBar: AppBar(title: const Text("Reading Session")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$minutes:${remainingSeconds.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),

          /// 🔔 Pengingat minimal halaman
          const Text(
            "Target minimal sesi ini: 5 halaman",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              timerController.start();
            },
            child: const Text("Start"),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              timerController.stop();
              showEndSessionDialog(context, ref);
            },
            child: const Text("End Session"),
          ),
        ],
      ),
    );
  }
}
