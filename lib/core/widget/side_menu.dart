import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/widget/models/side_menu_assets.dart';
import 'info_profile.dart';
import '../style/icon_sets.dart';
import 'side_menu_tile.dart';

class SideMenu extends StatefulWidget {
  static const routeName = '/side_bar';
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: AppColors.light.secondary,
        child: SafeArea(
          child: Column(
            children: [
              infoProfile(name: "Ayam", profesion: "not set"),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              ...asetIcon.map(
                (menu) =>
                    sideMenuTile(menu: menu, isActive: false, press: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
