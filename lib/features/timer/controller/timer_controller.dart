import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

class ReadingTimerController extends StateNotifier<int> {
  Timer? _timer;
  int _duration;

  ReadingTimerController(this._duration) : super(_duration * 60);

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        timer.cancel();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  int get durationMinutes => _duration;
}

final readingTimerProvider =
    StateNotifierProvider.autoDispose<ReadingTimerController, int>((ref) {
      return ReadingTimerController(25); // default 25 menit
    });
