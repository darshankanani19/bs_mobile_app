import 'package:beauty_salon/features/profile/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:beauty_salon/core/utils/route_names.dart';

import 'package:beauty_salon/features/home/view/screens/main_shell_screen.dart';
import 'package:beauty_salon/features/home/view/screens/home.dart';
import 'package:beauty_salon/features/calendar/view/screens/calendar_screen.dart';
import 'package:beauty_salon/features/appointments/view/screens/create_appointment_screen.dart';

import 'package:beauty_salon/features/authentication/view/screens/welcome_screen.dart';
import 'package:beauty_salon/features/authentication/view/screens/login_screen.dart';
import 'package:beauty_salon/features/authentication/view/screens/signup_screen.dart';
import 'package:beauty_salon/features/authentication/view/screens/forgot_password_screen.dart';
import 'package:beauty_salon/features/authentication/view/screens/reset_password_screen.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: Routes.welcome,
    routes: [
      /// -------- AUTH ROUTES --------
      _fadeRoute(path: Routes.welcome, child: const WelcomePage()),
      _fadeRoute(path: Routes.login, child: const LoginScreen()),
      _fadeRoute(path: Routes.signup, child: const SignUpScreen()),
      _fadeRoute(
        path: Routes.forgotPassword,
        child: const ForgotPasswordScreen(),
      ),
      _fadeRoute(
        path: Routes.resetPassword,
        child: const ResetPasswordScreen(),
      ),

      /// -------- MAIN SHELL (BOTTOM NAV) --------
      ShellRoute(
        builder: (context, state, child) {
          int index = 0;
          if (state.uri.path.startsWith(Routes.calendar)) {
            index = 1;
          }
          if (state.uri.path.startsWith(Routes.profile)) {
            index = 2;
          }
          return MainShellScreen(currentIndex: index, child: child);
        },
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (_, __) => const NoTransitionPage(child: Home()),
          ),
          GoRoute(
            path: Routes.calendar,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: CalendarScreen()),
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      /// -------- STACK PAGE --------
      _fadeRoute(
        path: Routes.createAppointment,
        child: const CreateAppointmentScreen(),
      ),
    ],
  );
}

GoRoute _fadeRoute({required String path, required Widget child}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 300),
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
