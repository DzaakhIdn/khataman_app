import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khataman_app/core/style/app_colors.dart';
import 'package:khataman_app/core/widget/models/side_menu_assets.dart';
import 'package:khataman_app/features/auth/provider/auth_provider.dart';
import 'info_profile.dart';
import 'side_menu_tile.dart';

class SideMenu extends ConsumerStatefulWidget {
  static const routeName = '/side_bar';
  const SideMenu({super.key});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  SideMenuAssets? selectedMenu;

  void _handleMenuNavigation(SideMenuAssets menu) {
    switch (menu.title) {
      case "Home":
        context.go('/home');
        break;
      case "History":
        // TODO: Navigate to history
        break;
      case "Settings":
        // TODO: Navigate to settings
        break;
      case "About":
        // TODO: Navigate to about
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userId = authState.userId;

    // Fetch profile jika user sudah login
    final profileAsync = userId != null
        ? ref.watch(userProfileProvider(userId))
        : null;

    final userName =
        profileAsync?.when(
          data: (profile) => profile?['username'] ?? 'User',
          loading: () => 'Loading...',
          error: (_, __) => 'User',
        ) ??
        'Guest';

    final supabaseClient = ref.read(supabaseClientProvider);
    final userEmail = supabaseClient.auth.currentUser?.email ?? 'not set';

    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: AppColors.light.secondary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              infoProfile(name: userName, profesion: userEmail),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              ...asetIcon.map(
                (menu) => sideMenuTile(
                  menu: menu,
                  isActive: selectedMenu == menu,
                  press: () {
                    setState(() {
                      selectedMenu = menu;
                    });
                    _handleMenuNavigation(menu);
                  },
                ),
              ),

              const Spacer(),

              // Logout button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Logout user
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        context.goNamed('/signin');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
