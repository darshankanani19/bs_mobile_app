// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mavemate/core/routes/app_routes.dart';
// import 'package:mavemate/core/network/api_result_service.dart';
// import 'package:mavemate/features/authentication/cubit/authentication_cubit.dart';
// import 'package:mavemate/features/authentication/repo/authentication_repo.dart';
// import 'package:mavemate/features/profile/cubit/profile_cubit.dart';
// import 'package:mavemate/features/profile/repo/profile_repo.dart';
// import 'package:mavemate/features/profile/service/profile_service.dart';
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final profileService = ProfileService();
//     // final profileService = ProfileService(apiService);
//     final profileRepo = ProfileRepository(service: profileService);
//
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => AuthenticationCubit(
//             authenticationRepo: AuthenticationRepo(),
//           ),
//         ),
//         BlocProvider(
//           create: (_) => ProfileCubit(
//             profileRepository: profileRepo,
//           ),
//         ),
//       ],
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         routerConfig: AppRoutes.router,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beauty_salon/core/routes/app_routes.dart';

import 'package:beauty_salon/features/authentication/cubit/authentication_cubit.dart';
import 'package:beauty_salon/features/authentication/repo/authentication_repo.dart';

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
