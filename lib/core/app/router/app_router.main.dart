part of 'app_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: SplashScreen.path,
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: SignUpScreen.path,
      builder: (context, state) => const SignUpScreen(),
    ),

    GoRoute(
      path: LogInScreen.path,
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: HomeScreen.path,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
