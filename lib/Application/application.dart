import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bs/Core/Route/app_routes.dart';

import 'package:bs/Feature/authentication/cubit/authentication_cubit.dart';
import 'package:bs/Feature/authentication/repo/authentication_repo.dart';

import 'package:bs/Feature/Booking/cubit/appointment_cubit.dart';
import 'package:bs/Feature/Booking/repo/appointment_repo.dart';

import 'package:bs/Feature/Booking/cubit/calendar_cubit.dart';
import 'package:bs/Feature/Booking/repo/calendar_repo.dart';
import 'package:bs/Feature/Booking/service/calendar_service.dart';

import 'package:bs/Feature/home/cubit/home_cubit.dart';
import 'package:bs/Feature/home/repo/home_repo.dart';
import 'package:bs/Feature/home/service/home_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthenticationCubit(authenticationRepo: AuthenticationRepo()),
        ),

        BlocProvider(
          create: (_) => AppointmentCubit(appointmentRepo: AppointmentRepo()),
        ),

        BlocProvider(
          create: (_) => CalendarCubit(CalendarRepo()),
        ),

        BlocProvider(create: (_) => HomeCubit(HomeRepo())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
