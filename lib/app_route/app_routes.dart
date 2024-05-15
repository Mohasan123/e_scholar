import 'package:e_scolar_app/home_screen/home_screen.dart';
import 'package:e_scolar_app/onboarding_screen/onboarding_screen.dart';
import 'package:e_scolar_app/signin_screen/signin_screen.dart';
import 'package:e_scolar_app/signup_screen/signup_screen.dart';
import 'package:e_scolar_app/splash_screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/onBoarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/Calendar',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
    initialLocation: '/',
  );
