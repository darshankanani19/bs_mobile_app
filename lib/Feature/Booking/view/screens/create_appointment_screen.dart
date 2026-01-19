import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/appointment_cubit.dart';
import '../../cubit/calendar_cubit.dart';
import '../../models/appointment_request_model.dart';
import '../../models/calendar_schedule_model.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final CalendarScheduleModel? appointment;

  const CreateAppointmentScreen({super.key, this.appointment});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final clientNameController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  int selectedHour = 0;
  int selectedMinute = 30;

  final hourController = FixedExtentScrollController();
  final minuteController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.appointment != null) {
      clientNameController.text = widget.appointment!.clientName;
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
    clientNameController.dispose();
    descriptionController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);
    const bg = Color(0xFFF6F8F7);

    return Scaffold(
      backgroundColor: bg,
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state.createStatus == FormzSubmissionStatus.success ||
              state.updateStatus == FormzSubmissionStatus.success) {
            context.read<CalendarCubit>().refresh();
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          final isLoading =
              state.createStatus == FormzSubmissionStatus.inProgress ||
              state.updateStatus == FormzSubmissionStatus.inProgress;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _field(
                    controller: clientNameController,
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
    );
  }

  // ===================== SUBMIT =====================

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) return;

    final totalMinutes = (selectedHour * 60) + selectedMinute;
    if (totalMinutes == 0) return;

    final payload = AppointmentRequestModel(
      client_name: clientNameController.text.trim(),
      start_time: selectedDate!.toUtc().toIso8601String(),
      duration_minutes: totalMinutes,
      description: descriptionController.text.trim(),
      status: 'scheduled',
    );

    final cubit = context.read<AppointmentCubit>();

    if (widget.appointment == null) {
      cubit.create(payload);
    } else {
      cubit.update(widget.appointment!.id, payload);
    }
  }

  // ===================== UI WIDGETS =====================

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
