import 'package:flutter/material.dart';
import '../../models/home_schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final HomeScheduleModel item;
  const ScheduleCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final statusText = () {
      switch (item.status) {
        case AppointmentStatus.completed:
          return 'COMPLETED';
        case AppointmentStatus.cancelled:
          return 'CANCELLED';
        default:
          return 'PENDING';
      }
    }();

    final statusColor = () {
      switch (item.status) {
        case AppointmentStatus.completed:
          return const Color(0xFF2ECC71);
        case AppointmentStatus.cancelled:
          return Colors.redAccent;
        default:
          return const Color(0xFFFFA000);
      }
    }();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline),
          ),
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
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
