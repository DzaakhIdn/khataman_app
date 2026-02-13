import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/utils/rive_utils.dart';
import 'package:khataman_app/core/widget/menu_btn.dart';
import 'package:khataman_app/core/widget/side_menu.dart';
import 'package:rive/rive.dart';

class Entry extends ConsumerStatefulWidget {
  static const routeName = '/entry';
  final Widget child;

  const Entry({super.key, required this.child});

  @override
  ConsumerState<Entry> createState() => _EntryState();
}

class _EntryState extends ConsumerState<Entry>
    with SingleTickerProviderStateMixin {
  SMIBool? isSideBarClosed;
  AnimationController? _animationController;
  Animation<double>? animation;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.fastOutSlowIn,
      ),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  bool isSideMenuClosed = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.secondary,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation!.value - 30 * animation!.value * pi / 180),
            child: Transform(
              transform: Matrix4.identity()
                ..translate((animation?.value ?? 0) * 265)
                ..scale((scaleAnimation?.value ?? 1.0)),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  (animation?.value ?? 0) * 24,
                ),
                child: widget.child,
              ),
            ),
          ),
          menuButton(
            riveOnInit: (artboard) {
              StateMachineController? controller;
              controller = RiveUtils.getRiveController(
                artboard,
                stateMachineName: "SM1",
              );

              if (controller != null) {
                isSideBarClosed = controller.findSMI("open") as SMIBool?;
                isSideBarClosed?.value = false;
              }
            },
            press: () {
              isSideBarClosed?.value = !(isSideBarClosed?.value ?? true);

              if (isSideMenuClosed) {
                _animationController?.forward();
              } else {
                _animationController?.reverse();
              }

              setState(() {
                isSideMenuClosed = !isSideMenuClosed;
              });
            },
          ),
        ],
      ),
    );
  }
}
