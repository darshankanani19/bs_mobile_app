import 'package:bs/Core/Util/route_names.dart';
import 'package:bs/Feature/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../models/calendar_schedule_model.dart';
import '../../cubit/appointment_cubit.dart';
import '../../cubit/calendar_cubit.dart';

class AppointmentCard extends StatelessWidget {
  final CalendarScheduleModel item;

  const AppointmentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);
    const grayText = Colors.black54;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mint.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: mint.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// TIME
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.timeFrom,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.timeTo,
                style: const TextStyle(fontSize: 13, color: grayText),
              ),
            ],
          ),

          const SizedBox(width: 16),

          /// VERTICAL LINE
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: mint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(width: 16),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.clientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 14, color: grayText),
                ),
                const SizedBox(height: 6),
                Text(
                  item.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: grayText,
                  ),
                ),
              ],
            ),
          ),

          /// MENU
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black45),
            onSelected: (value) async {
              if (value == 'edit') {
                context.push(Routes.updateAppointment, extra: item);
              }

              if (value == 'delete') {
                await context.read<AppointmentCubit>().delete(item.id);
                context.read<CalendarCubit>().refresh();
                context.read<HomeCubit>().reload();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text("Edit")),
              PopupMenuItem(
                value: 'delete',
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
