import 'package:go_router/go_router.dart';
import 'package:khataman_app/features/auth/pages/signin_screen.dart';
import 'package:khataman_app/features/splash_screen.dart';
import 'package:khataman_app/features/home/pages/home_page.dart';

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
    GoRoute(path: HomePage.routeName, builder: (_, __) => const HomePage()),
  ],
);
