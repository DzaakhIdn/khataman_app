import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:khataman_app/core/style/app_colors.dart';

class infoProfile extends StatelessWidget {
  const infoProfile({super.key, required this.name, required this.profesion});

  final String name, profesion;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white24,
        child: Iconify(Ph.user_duotone, color: Colors.white),
      ),
      title: Text(
        name,
        style: GoogleFonts.raleway(
          textStyle: TextStyle(
            color: AppColors.light.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: Text(
        profesion,
        style: GoogleFonts.raleway(
          textStyle: TextStyle(color: AppColors.light.textPrimary),
        ),
      ),
    );
  }
}
