import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Util/route_names.dart';
import '../helper/storage_helper.dart';

// AUTH
import '../../Feature/authentication/view/screens/welcome_screen.dart';
import '../../Feature/authentication/view/screens/login_screen.dart';
import '../../Feature/authentication/view/screens/signup_screen.dart';
import '../../Feature/authentication/view/screens/forgot_password_screen.dart';
import '../../Feature/authentication/view/screens/reset_password_screen.dart';

// MAIN
import '../../Feature/home/view/screens/main_shell_screen.dart';
import '../../Feature/home/view/screens/home.dart';
import '../../Feature/Booking/view/screens/calendar_screen.dart';
import '../../Feature/profile/view/screens/profile_screen.dart';

// APPOINTMENTS
import '../../Feature/Booking/view/screens/create_appointment_screen.dart';
import '../../Feature/Booking/models/calendar_schedule_model.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.welcome,

    // 🔐 AUTH GUARD (ASYNC SAFE)
    redirect: (context, state) async {
      final token = await StorageHelper.getAccessToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      final isAuthRoute =
          state.uri.path == Routes.welcome ||
          state.uri.path == Routes.login ||
          state.uri.path == Routes.signup ||
          state.uri.path == Routes.forgotPassword ||
          state.uri.path == Routes.resetPassword;

      // ❌ Not logged in → block app pages
      if (!isLoggedIn && !isAuthRoute) {
        return Routes.welcome;
      }

      // ✅ Logged in → block auth pages
      if (isLoggedIn && isAuthRoute) {
        return Routes.home;
      }

      return null; // allow navigation
    },

    routes: [
      // ================= AUTH =================
      GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomePage()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.signup, builder: (_, __) => const SignUpScreen()),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (_, __) => const ResetPasswordScreen(),
      ),

      // ================= MAIN SHELL =================
      ShellRoute(
        builder: (context, state, child) {
          int index = 0;
          if (state.uri.path.startsWith(Routes.calendar)) index = 1;
          if (state.uri.path.startsWith(Routes.profile)) index = 2;

          return MainShellScreen(currentIndex: index, child: child);
        },
        routes: [
          // HOME
          GoRoute(path: Routes.home, builder: (_, __) => const Home()),

          // CALENDAR
          GoRoute(
            path: Routes.calendar,
            builder: (_, __) => const CalendarScreen(),
          ),

          // PROFILE
          GoRoute(
            path: Routes.profile,
            builder: (_, __) => const ProfileScreen(),
          ),

          // CREATE APPOINTMENT
          GoRoute(
            path: Routes.createAppointment,
            builder: (_, __) => const CreateAppointmentScreen(),
          ),

          // UPDATE APPOINTMENT
          GoRoute(
            path: Routes.updateAppointment,
            builder: (_, state) {
              final CalendarScheduleModel item =
                  state.extra as CalendarScheduleModel;
              return CreateAppointmentScreen(appointment: item);
            },
          ),
        ],
      ),
    ],
  );
}
