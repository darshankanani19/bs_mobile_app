import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/calendar_cubit.dart';
import '../../cubit/calendar_state.dart';
import '../widgets/appointment_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Column(
          children: [
            _CalendarRow(
              selectedDate: state.selectedDate,
              onSelect: (date) {
                context.read<CalendarCubit>().loadAppointments(date);
              },
            ),

            Expanded(child: _AppointmentsList(state: state)),
          ],
        );
      },
    );
  }
}

/* ---------------- CALENDAR ROW ---------------- */

class _CalendarRow extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  const _CalendarRow({required this.selectedDate, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (_, i) {
          final day = start.add(Duration(days: i));
          final isSelected = DateUtils.isSameDay(day, selectedDate);

          return GestureDetector(
            onTap: () => onSelect(day),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFAEC6C1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(DateFormat('E').format(day)),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('d').format(day),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ---------------- APPOINTMENTS LIST ---------------- */

class _AppointmentsList extends StatelessWidget {
  final CalendarState state;
  const _AppointmentsList({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == CalendarStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.appointments.isEmpty) {
      return const Center(child: Text("No appointments"));
    }

    return ListView(
      children: state.appointments
          .map((e) => AppointmentCard(item: e))
          .toList(),
    );
  }
}
