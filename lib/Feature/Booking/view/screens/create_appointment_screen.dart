import 'package:bs/Feature/Booking/cubit/appointment_state.dart';
import 'package:bs/Feature/Booking/models/calendar_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bs/Feature/Booking/cubit/appointment_cubit.dart';
import 'package:bs/Feature/Booking/models/appointment_request_model.dart';
import 'package:bs/Feature/Booking/repo/appointment_repo.dart';
import 'package:bs/Feature/Booking/service/appointment_service.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final CalendarScheduleModel? appointment;

  const CreateAppointmentScreen({super.key, this.appointment});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final clientName = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;

  int selectedHour = 0;
  int selectedMinute = 0;

  final FixedExtentScrollController hourController =
      FixedExtentScrollController();
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.appointment != null) {
      clientName.text = widget.appointment!.clientName;
      descriptionController.text = widget.appointment!.description;
      selectedDate = widget.appointment!.startTime;

      selectedHour = widget.appointment!.durationMinutes ~/ 60;
      selectedMinute = widget.appointment!.durationMinutes % 60;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        hourController.jumpToItem(selectedHour);
        minuteController.jumpToItem(selectedMinute);
      });
    }
  }

  @override
  void dispose() {
    clientName.dispose();
    descriptionController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);
    const bg = Color(0xFFF6F8F7);

    return BlocProvider(
      create: (_) => AppointmentCubit(AppointmentRepo(AppointmentService())),
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: mint,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(false),
          ),
          title: Text(
            widget.appointment == null
                ? "New Appointment"
                : "Update Appointment",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<AppointmentCubit, AppointmentState>(
          listener: (context, state) {
            if (state.status == AppointmentStatus.success) {
              /// ✅ IMPORTANT
              /// return true so previous page can reload
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            if (state.status == AppointmentStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(
                      controller: clientName,
                      label: "Client Name",
                      hint: "Enter Client Name",
                    ),
                    const SizedBox(height: 16),

                    _datePicker(
                      label: "Select Date",
                      value: selectedDate,
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          initialDate: selectedDate ?? DateTime.now(),
                        );

                        if (d != null) {
                          final now = DateTime.now();
                          setState(() {
                            selectedDate = DateTime(
                              d.year,
                              d.month,
                              d.day,
                              now.hour,
                              now.minute,
                            );
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    _durationPicker(),

                    const SizedBox(height: 16),

                    _field(
                      controller: descriptionController,
                      label: "Description",
                      hint: "Service description",
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mint,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _submit,
                      child: Text(
                        widget.appointment == null
                            ? "Book Appointment"
                            : "Update Appointment",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) return;

    final totalMinutes = (selectedHour * 60) + selectedMinute;
    if (totalMinutes == 0) return;

    final payload = AppointmentRequestModel(
      client_name: clientName.text.trim(),
      start_time: selectedDate!.toUtc().toIso8601String(),
      duration_minutes: totalMinutes,
      description: descriptionController.text.trim(),
      status: 'scheduled',
    );

    final cubit = context.read<AppointmentCubit>();

    if (widget.appointment == null) {
      cubit.createAppointment(payload);
    } else {
      cubit.updateAppointment(
        appointmentId: widget.appointment!.id,
        payload: payload,
      );
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _datePicker({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFAEC6C1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value == null
                  ? label
                  : "${value.day}/${value.month}/${value.year}",
              style: const TextStyle(color: Colors.black54),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _durationPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _wheel("hour", 24, hourController, (v) => selectedHour = v),
        const SizedBox(width: 24),
        _wheel("minute", 60, minuteController, (v) => selectedMinute = v),
      ],
    );
  }

  Widget _wheel(
    String label,
    int max,
    FixedExtentScrollController controller,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (i) => onChanged(i % max),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (_, i) => Center(
                child: Text(
                  (i % max).toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
        ),
        Text(label),
      ],
    );
  }
}
