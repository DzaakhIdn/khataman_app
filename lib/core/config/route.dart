import 'package:go_router/go_router.dart';
import 'package:khataman_app/core/widget/side_menu.dart';
import 'package:khataman_app/features/auth/pages/signin_screen.dart';
import 'package:khataman_app/features/auth/pages/signup_screen.dart';
import 'package:khataman_app/features/splash_screen.dart';
import 'package:khataman_app/features/home/pages/home_page.dart';
import 'package:khataman_app/features/target/pages/target_pages.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: [
    GoRoute(
      path: SplashScreen.routeName,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: SignInScreen.routeName,
      builder: (_, __) => const SignInScreen(),
    ),
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (_, __) => const SignUpScreen(),
    ),
    GoRoute(path: HomePage.routeName, builder: (_, __) => const HomePage()),
    GoRoute(
      path: TargetPages.routeName,
      builder: (_, __) => const TargetPages(),
    ),
    GoRoute(path: SideMenu.routeName, builder: (_, __) => const SideMenu()),
  ],
);
