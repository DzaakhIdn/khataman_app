import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class menuButton extends StatelessWidget {
  const menuButton({super.key, required this.press, required this.riveOnInit});

  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 16),
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            color: Color.fromARGB(172, 16, 185, 129),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: RiveAnimation.asset(
            "assets/animated_icon/menu.riv",
            onInit: riveOnInit,
          ),
        ),
      ),
    );
  }
}
