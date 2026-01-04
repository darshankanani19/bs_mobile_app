import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bs/core/Util/route_names.dart';

import 'package:bs/Feature/Booking/cubit/appointment_cubit.dart';
import 'package:bs/Feature/Booking/repo/appointment_repo.dart';
import 'package:bs/Feature/Booking/service/appointment_service.dart';
import 'package:bs/Feature/Booking/models/calendar_schedule_model.dart';

import 'package:bs/Feature/home/view/screens/main_shell_screen.dart';
import 'package:bs/Feature/home/view/screens/home.dart';
import 'package:bs/Feature/Booking/view/screens/calendar_screen.dart';
import 'package:bs/Feature/Booking/view/screens/create_appointment_screen.dart';
import 'package:bs/Feature/profile/view/screens/profile_screen.dart';

import 'package:bs/Feature/authentication/view/screens/welcome_screen.dart';
import 'package:bs/Feature/authentication/view/screens/login_screen.dart';
import 'package:bs/Feature/authentication/view/screens/signup_screen.dart';
import 'package:bs/Feature/authentication/view/screens/forgot_password_screen.dart';
import 'package:bs/Feature/authentication/view/screens/reset_password_screen.dart';

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

      /// -------- MAIN SHELL (GLOBAL CUBITS HERE) --------
      ShellRoute(
        builder: (context, state, child) {
          int index = 0;
          if (state.uri.path.startsWith(Routes.calendar)) index = 1;
          if (state.uri.path.startsWith(Routes.profile)) index = 2;

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    AppointmentCubit(AppointmentRepo(AppointmentService())),
              ),
            ],
            child: MainShellScreen(currentIndex: index, child: child),
          );
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

      /// -------- CREATE APPOINTMENT (NO CUBIT HERE) --------
      GoRoute(
        name: Routes.createAppointment,
        path: '/create-appointment',
        builder: (_, __) => const CreateAppointmentScreen(),
      ),

      /// -------- UPDATE APPOINTMENT --------
      GoRoute(
        name: 'update-Appointment',
        path: '/update-appointment',
        builder: (context, state) {
          final appointment = state.extra as CalendarScheduleModel;
          return CreateAppointmentScreen(appointment: appointment);
        },
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
