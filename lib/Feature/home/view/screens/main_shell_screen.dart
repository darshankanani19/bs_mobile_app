import 'package:bs/Core/Util/app_strings.dart';
import 'package:bs/Core/Util/route_names.dart';
import 'package:bs/Feature/Booking/cubit/calendar_cubit.dart';
import 'package:bs/Feature/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bs/Core/Util/app_colors.dart';
import 'package:bs/Feature/home/cubit/home_cubit.dart';
import 'package:bs/Feature/home/repo/home_repo.dart';
import 'package:bs/Feature/home/service/home_service.dart';

class MainShellScreen extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const MainShellScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(HomeRepo())..load(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8F7),

        appBar: currentIndex == 0
            ? AppBar(
                elevation: 0,
                backgroundColor: const Color(0xFFF6F8F7),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black87,
                  ),
                  onPressed: () {},
                ),
                title: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final title = 'Today';
                    return Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            : AppBar(
                backgroundColor: AppColors.primaryColor,
                title: Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),

        body: child,

        floatingActionButton: (currentIndex == 0 || currentIndex == 1)
            ? FloatingActionButton(
                backgroundColor: AppColors.mint,
                onPressed: () async {
                  final result = await context.push('/create-appointment');

                  if (result == true) {
                    context.read<CalendarCubit>().loadAppointments(
                      context.read<CalendarCubit>().state.selectedDate,
                    );
                  }
                },
                child: const Icon(Icons.add, color: Colors.black),
              )
            : null,

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: AppColors.mint,
          unselectedItemColor: Colors.black38,
          onTap: (i) {
            if (i == 0) context.go(Routes.home);
            if (i == 1) context.go(Routes.calendar);
            if (i == 2) context.go(Routes.profile);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
