import 'package:go_router/go_router.dart';
import 'package:khataman_app/features/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: [
    GoRoute(
      path: SplashScreen.routeName,
      builder: (_, __) => const SplashScreen(),
    ),
  ],
);
