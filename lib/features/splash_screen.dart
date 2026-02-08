import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static String patern = 'assets/splashscreen/pattern.svg';
  late final SupabaseClient client;

  @override
  void initState() {
    super.initState();
    // _redirect();
  }

  // Future<void> _redirect() async {
  //   await Future.delayed(Duration.zero);
  //   final session = client.auth.currentSession;
  //   if(session != null ){
  //     context.pushReplacementNamed()
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 285,
            top: 30,
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(patern, width: 250),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(patern, width: 200, height: 200),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 50,
              children: [
                RichText(
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
                SpinKitCircle(color: AppColors.light.primary, size: 40.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
