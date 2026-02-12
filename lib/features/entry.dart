import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/utils/rive_utils.dart';
import 'package:khataman_app/core/widget/menu_btn.dart';
import 'package:khataman_app/core/widget/side_menu.dart';
import 'package:khataman_app/features/home/pages/home_page.dart';
import 'package:rive/rive.dart';

class Entry extends ConsumerStatefulWidget {
  static const routeName = '/entry';
  const Entry({super.key});

  @override
  ConsumerState<Entry> createState() => _EntryState();
}

class _EntryState extends ConsumerState<Entry>
    with SingleTickerProviderStateMixin {
  SMIBool? isSideBarClosed;
  late AnimationController _animationController;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isSideMenuClosed = false;
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
            left: isSideMenuClosed ? 288 : 0,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(),
          ),
          Transform.translate(
            offset: Offset(animation.value * 288, 0),
            child: Transform.scale(
              scale: isSideMenuClosed ? 1 : 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isSideMenuClosed ? 0 : 24),
                child: const HomePage(),
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
              isSideBarClosed!.value = !isSideBarClosed!.value;
              if (isSideMenuClosed) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
              setState(() {
                isSideMenuClosed = isSideBarClosed!.value;
              });
            },
          ),
        ],
      ),
    );
  }
}
