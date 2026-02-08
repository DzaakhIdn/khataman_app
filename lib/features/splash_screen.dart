import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/features/auth/provider/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Tunggu 2 detik untuk splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      try {
        // Cek authentication status
        final authState = ref.read(authProvider);

        if (authState.user != null) {
          // User sudah login, ke home
          context.go('/home');
        } else {
          // User belum login, ke signin
          context.go('/signin');
        }
      } catch (e) {
        // Jika ada error, langsung ke signin
        debugPrint('Error checking auth: $e');
        context.go('/signin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String patern = 'assets/splashscreen/pattern.svg';

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
