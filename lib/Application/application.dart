import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs/Core/Route/app_routes.dart';
import 'package:bs/Feature/authentication/cubit/authentication_cubit.dart';
import 'package:bs/Feature/authentication/repo/authentication_repo.dart';

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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
