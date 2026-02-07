import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/core/style/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // static String patern = 'assets/splashscreen/pattern.svg';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Khatam \n",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 70,
                      fontWeight: FontWeight.w600,
                      color: AppColors.light.primary,
                      height: 0.7,
                    ),
                  ),
                  TextSpan(
                    text: "Ramadhan",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 70,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: AppColors.light.secondary,
                      height: 0.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
