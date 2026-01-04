import 'package:bs/Core/Util/route_names.dart';
import 'package:bs/Feature/Booking/cubit/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bs/Feature/Booking/models/calendar_schedule_model.dart';

class AppointmentCard extends StatelessWidget {
  final CalendarScheduleModel item;

  const AppointmentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);
    const grayText = Colors.black54;

    return GestureDetector(
      onTap: () => _showActionDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: mint.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: mint.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
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
                  style: const TextStyle(color: grayText, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(width: 16),

            /// LINE
            Container(
              width: 4,
              height: 45,
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
                      color: grayText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.more_vert, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  // ---------- ACTION DIALOG ----------

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Manage Appointment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("What would you like to do?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              /// ✅ FULL SCREEN UPDATE (go_router)
              context.pushNamed('update-Appointment', extra: item);
            },
            child: const Text("Update", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _confirmDelete(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Appointment"),
        content: const Text(
          "Are you sure you want to delete this appointment?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // call delete cubit here later
              Navigator.pop(dialogContext);
              context.read<CalendarCubit>().refresh();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
