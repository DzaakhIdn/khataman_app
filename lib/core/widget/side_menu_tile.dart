import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/widget/models/side_menu_assets.dart';

class sideMenuTile extends StatelessWidget {
  const sideMenuTile({
    super.key,
    required this.menu,
    required this.press,
    required this.isActive,
  });

  final SideMenuAssets menu;
  final VoidCallback press;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(color: Colors.white24, height: 1),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 300),
              height: 56,
              width: isActive ? 288 : 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ListTile(
              onTap: press,
              leading: SizedBox(
                height: 34,
                width: 34,
                child: Iconify(menu.icon, color: Colors.black38),
              ),
              title: Text(
                menu.title,
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(color: AppColors.light.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
