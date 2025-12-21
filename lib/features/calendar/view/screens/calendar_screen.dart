import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:beauty_salon/core/utils/route_names.dart';
import 'package:beauty_salon/features/calendar/cubit/calendar_cubit.dart';
import 'package:beauty_salon/features/calendar/cubit/calendar_state.dart';
import 'package:beauty_salon/features/calendar/repo/calendar_repo.dart';
import 'package:beauty_salon/features/calendar/service/calendar_service.dart';
import 'package:beauty_salon/features/calendar/view/widgets/appointment_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);

    return BlocProvider(
      create: (_) =>
          CalendarCubit(CalendarRepo(CalendarService()))
            ..loadAppointments(DateTime.now()),
      child: BlocConsumer<CalendarCubit, CalendarState>(
        listener: (context, state) {
          if (state.status == CalendarStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? "Action failed")),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CalendarStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              _buildCalendarRow(context, state.selectedDate, mint),

              const SizedBox(height: 16),

              if (state.appointments.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text("No appointments"),
                )
              else
                ...state.appointments.map((e) => AppointmentCard(item: e)),

              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendarRow(
    BuildContext context,
    DateTime selectedDate,
    Color mint,
  ) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    final days = List.generate(31, (i) {
      final day = firstDayOfWeek.add(Duration(days: i));
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.black87,
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
