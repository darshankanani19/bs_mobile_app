import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bs/Feature/Booking/cubit/appointment_cubit.dart';
import 'package:bs/Feature/home/models/home_schedule_model.dart';
import 'package:bs/Feature/home/cubit/home_cubit.dart';

class ScheduleCard extends StatelessWidget {
  final HomeScheduleModel item;
  const ScheduleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.status == AppointmentStatus.completed;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.service,
                      style: const TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.timeText),
                  const SizedBox(height: 6),
                  Text(
                    isCompleted ? "COMPLETED" : "PENDING",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFFFA000),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ACTION BUTTONS
          Row(
            children: [
              /// PAYMENT (UI ONLY)
              OutlinedButton(onPressed: () {}, child: const Text("Payment")),
              const Spacer(),

              /// EDIT
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  context.pushNamed('update-Appointment', extra: item);
                },
              ),

              /// DELETE
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Appointment"),
        content: const Text(
          "Are you sure you want to delete this appointment?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<AppointmentCubit>().deleteAppointment(
                item.id as int,
              );
              context.read<HomeCubit>().load();
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
