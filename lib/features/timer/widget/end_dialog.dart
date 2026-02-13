import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/features/timer/controller/timer_controller.dart';
import 'package:khataman_app/features/timer/models/timer_model.dart';
import 'package:khataman_app/features/timer/timer_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void showEndSessionDialog(BuildContext context, WidgetRef ref) {
  final pagesController = TextEditingController();
  final juzFromController = TextEditingController();
  final juzToController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pagesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Halaman Dibaca"),
            ),
            TextField(
              controller: juzFromController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Dari Juz"),
            ),
            TextField(
              controller: juzToController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Sampai Juz"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = Supabase.instance.client.auth.currentUser;

                final repo = ReadingSessionRepository(Supabase.instance.client);

                final timer = ref.read(readingTimerProvider.notifier);

                final session = ReadingSessionModel(
                  id: '',
                  userId: user!.id,
                  sessionDate: DateTime.now(),
                  durationMinutes: timer.durationMinutes,
                  pagesRead: double.tryParse(pagesController.text),
                  juzFrom: double.tryParse(juzFromController.text),
                  juzTo: double.tryParse(juzToController.text),
                  targetId: null,
                );

                await repo.insertSession(session);

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Save Session"),
            ),
          ],
        ),
      );
    },
  );
}
