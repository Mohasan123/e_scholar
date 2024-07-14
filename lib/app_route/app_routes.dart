import 'package:e_scolar_app/admin/home_admin/widgets/add_User.dart';
import 'package:e_scolar_app/admin/home_admin/widgets/add_class.dart';
import 'package:e_scolar_app/admin/home_admin/widgets/add_planing.dart';
import 'package:e_scolar_app/admin/home_screen_admin/home_admin.dart';
import 'package:e_scolar_app/onboarding_screen/onboarding_screen.dart';
import 'package:e_scolar_app/professor/home_prof/widgets/add_note.dart';
import 'package:e_scolar_app/professor/home_screen_professor/home_Professor.dart';
import 'package:e_scolar_app/signin_screen/signin_screen.dart';
import 'package:e_scolar_app/signup_screen/signup_screen.dart';
import 'package:e_scolar_app/splash_screen/splash_screen.dart';
import 'package:e_scolar_app/student/home_screen_student/home_student.dart';
import 'package:e_scolar_app/student/home_stud/widgets/request_document.dart';
import 'package:go_router/go_router.dart';

import '../admin/home_admin/widgets/AddModal.dart';
import '../student/home_screen_student/noteUtils/student_note.dart';

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
      path: '/home/professor',
      builder: (context, state) => const HomeProfessor(),
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
    GoRoute(
      path: '/addCourse',
      builder: (context, state) => const AddClass(),
    ),
    GoRoute(
      path: '/addPlaning',
      builder: (context, state) => const AddPlaning(),
    ),
    GoRoute(
      path: '/addNote',
      builder: (context, state) => const AddNote(),
    ),
    GoRoute(
        path: '/studentNote/:studentId',
        builder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return StudentNoteScreen(
            studentId: studentId,
          );
        }),
    GoRoute(
      path: '/requestDocument',
      builder: (context, state) => const DocumentRequest(),
    ),
  ],
  initialLocation: '/signIn',
);
