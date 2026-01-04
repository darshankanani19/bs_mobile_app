import 'package:bs/Feature/Booking/cubit/calendar_state.dart';
import 'package:bs/Feature/Booking/cubit/calendar_cubit.dart';
import 'package:bs/Feature/Booking/repo/calendar_repo.dart';
import 'package:bs/Feature/Booking/service/calendar_service.dart';
import 'package:bs/Feature/Booking/view/widgets/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);

    return BlocProvider(
      create: (_) => CalendarCubit(CalendarRepo(CalendarService())),
      child: ListView(
        children: [
          /// CALENDAR ROW
          BlocBuilder<CalendarCubit, CalendarState>(
            buildWhen: (p, c) => p.selectedDate != c.selectedDate,
            builder: (context, state) {
              return _buildCalendarRow(context, state.selectedDate, mint);
            },
          ),

          const SizedBox(height: 16),

          /// APPOINTMENTS LIST
          BlocBuilder<CalendarCubit, CalendarState>(
            buildWhen: (p, c) =>
                p.status != c.status || p.appointments != c.appointments,
            builder: (context, state) {
              if (state.status == CalendarStatus.loading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.appointments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text("No appointments"),
                );
              }

              return Column(
                children: state.appointments
                    .map((e) => AppointmentCard(item: e))
                    .toList(),
              );
            },
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCalendarRow(
    BuildContext context,
    DateTime selectedDate,
    Color mint,
  ) {
    final now = DateTime.now();
    final firstDay = now.subtract(Duration(days: now.weekday - 1));

    final days = List.generate(31, (i) {
      final day = firstDay.add(Duration(days: i));
      final isSelected = DateUtils.isSameDay(day, selectedDate);

      return GestureDetector(
        onTap: () => context.read<CalendarCubit>().selectDate(day),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? mint : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('E').format(day),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('d').format(day),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(children: days),
    );
  }
}
