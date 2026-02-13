import 'package:go_router/go_router.dart';
import 'package:khataman_app/features/auth/pages/signin_screen.dart';
import 'package:khataman_app/features/auth/pages/signup_screen.dart';
import 'package:khataman_app/features/entry.dart';
import 'package:khataman_app/features/splash_screen.dart';
import 'package:khataman_app/features/home/pages/home_page.dart';
import 'package:khataman_app/features/target/pages/target_pages.dart';
import 'package:khataman_app/features/timer/pages/timer_page.dart';

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
    GoRoute(
      path: TargetPages.routeName,
      builder: (_, __) => const TargetPages(),
    ),
    ShellRoute(
      builder: (context, state, child) => Entry(child: child),
      routes: [
        GoRoute(path: HomePage.routeName, builder: (_, __) => HomePage()),
        GoRoute(
          path: ReadingSessionPage.routeName,
          builder: (_, __) => ReadingSessionPage(),
        ),
      ],
    ),
  ],
);
