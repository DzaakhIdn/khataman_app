import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/core/widget/menu_btn.dart';
import 'package:khataman_app/features/home/pages/home_page.dart';
import 'package:rive/rive.dart';

class Entry extends ConsumerStatefulWidget {
  static const routeName = '/entry';
  const Entry({super.key});

  @override
  ConsumerState<Entry> createState() => _EntryState();
}

class _EntryState extends ConsumerState<Entry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [const HomePage(), menuButton()]));
  }
}
