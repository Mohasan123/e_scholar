<<<<<<< HEAD
import 'package:e_scolar_app/admin/home_admin/widgets/add_User.dart';
import 'package:e_scolar_app/admin/home_screen_admin/home_admin.dart';
import 'package:e_scolar_app/onboarding_screen/onboarding_screen.dart';
import 'package:e_scolar_app/professor/home_screen_professor/home_Professor.dart';
import 'package:e_scolar_app/signin_screen/signin_screen.dart';
import 'package:e_scolar_app/signup_screen/signup_screen.dart';
import 'package:e_scolar_app/splash_screen/splash_screen.dart';
import 'package:e_scolar_app/student/home_screen_student/home_student.dart';
import 'package:go_router/go_router.dart';

import '../admin/home_admin/widgets/AddModal.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeStudent(),
      // const HomeScreen(role: UserRole.student),
    ),
    GoRoute(
      path: '/home/admin',
      builder: (context, state) => const HomeAdmin(),
      // const HomeScreen(role: UserRole.admin),
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
    GoRoute(
      path: '/addUser',
      builder: (context, state) => const AddUser(),
    ),
    GoRoute(
      path: '/addModal',
      builder: (context, state) => const AddModal(),
    ),
  ],
  initialLocation: '/signIn',
);
=======
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
>>>>>>> 7961d6c2c2f8e2551eeff971619272f84bc666cf
