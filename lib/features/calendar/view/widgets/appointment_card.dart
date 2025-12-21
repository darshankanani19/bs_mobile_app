import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/calendar_cubit.dart';
import '../../models/calendar_schedule_model.dart';

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
            Container(
              width: 4,
              height: 45,
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
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
                  Text(
                    item.service,
                    style: const TextStyle(fontSize: 14, color: grayText),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.staffName,
                    style: const TextStyle(fontSize: 13, color: grayText),
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

  // ---------------- DIALOGS ----------------

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
              Navigator.pop(dialogContext); // ✅ close only this dialog
              _showUpdateDialog(context);
            },
            child: const Text("Update", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CalendarCubit>().deleteBooking(item.id);
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

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Update Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusTile(context, dialogContext, "confirmed"),
            _statusTile(context, dialogContext, "completed"),
            _statusTile(context, dialogContext, "cancelled"),
            _statusTile(context, dialogContext, "pending"),
            _statusTile(context, dialogContext, "confirmed"),
          ],
        ),
      ),
    );
  }

  Widget _statusTile(
    BuildContext context,
    BuildContext dialogContext,
    String status,
  ) {
    return ListTile(
      title: Text(status.toUpperCase()),
      onTap: () {
        Navigator.pop(dialogContext); // ✅ close update dialog safely
        context.read<CalendarCubit>().updateBooking(
          bookingId: item.id,
          status: status,
        );
      },
    );
  }
}
