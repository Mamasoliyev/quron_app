part of 'app_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUpScreen(),
    ),

    GoRoute(path: '/log_in', builder: (context, state) => LogInScreen()),
  ],
);
