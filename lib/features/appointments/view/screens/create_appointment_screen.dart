import 'package:beauty_salon/core/utils/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:beauty_salon/features/appointments/cubit/appointment_cubit.dart';
import 'package:beauty_salon/features/appointments/cubit/appointment_state.dart';
import 'package:beauty_salon/features/appointments/models/appointment_model.dart';
import 'package:beauty_salon/features/appointments/models/client_model.dart';
import 'package:beauty_salon/features/appointments/repo/appointment_repo.dart';
import 'package:beauty_salon/features/appointments/service/appointment_service.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedService;
  String? selectedStaff;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mint = Color(0xFFAEC6C1);
    const lightGray = Color(0xFFF6F8F7);

    return BlocProvider(
      create: (_) =>
          AppointmentCubit(AppointmentRepo(AppointmentService()))
            ..loadDropdownData(), // ✅ load service & staff from backend
      child: Scaffold(
        backgroundColor: lightGray,
        appBar: AppBar(
          backgroundColor: mint,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(), // ✅ fixed back navigation
          ),
          title: const Text(
            "New Appointment",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<AppointmentCubit, AppointmentState>(
          listener: (context, state) {
            if (state.status == AppointmentStatus.success &&
                state.services.isNotEmpty &&
                state.staffMembers.isNotEmpty) {
              // ✅ services & staff loaded successfully
            } else if (state.status == AppointmentStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Appointment Created Successfully"),
                ),
              );
              context.go(Routes.home);
            }
          },
          builder: (context, state) {
            if (state.status == AppointmentStatus.loading &&
                state.services.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("First Name"),
                    TextFormField(
                      controller: firstNameController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter first name" : null,
                      decoration: _inputDecoration("Enter first name", mint),
                    ),
                    const SizedBox(height: 16),

                    _label("Last Name"),
                    TextFormField(
                      controller: lastNameController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter last name" : null,
                      decoration: _inputDecoration("Enter last name", mint),
                    ),
                    const SizedBox(height: 16),

                    _label("Contact Number"),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.isEmpty
                          ? "Enter contact number"
                          : null,
                      decoration: _inputDecoration(
                        "Enter contact number",
                        mint,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _label("Email ID"),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter email address" : null,
                      decoration: _inputDecoration("Enter email", mint),
                    ),
                    const SizedBox(height: 16),

                    _label("Service"),
                    DropdownButtonFormField<String>(
                      value: selectedService,
                      items: state.services
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedService = value),
                      decoration: _inputDecoration("Select service", mint),
                      validator: (v) =>
                          v == null ? "Please select a service" : null,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _dateTimeField(
                            label: "Select Date",
                            icon: Icons.calendar_today,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null)
                                setState(() => selectedDate = picked);
                            },
                            value: selectedDate != null
                                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dateTimeField(
                            label: "Select Time",
                            icon: Icons.access_time,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null)
                                setState(() => selectedTime = picked);
                            },
                            value: selectedTime?.format(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _label("Staff Member"),
                    DropdownButtonFormField<String>(
                      value: selectedStaff,
                      items: state.staffMembers
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedStaff = value),
                      decoration: _inputDecoration("Assign staff", mint),
                      validator: (v) =>
                          v == null ? "Please select a staff member" : null,
                    ),
                    const SizedBox(height: 16),

                    _label("Notes (Optional)"),
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        "Add special requests...",
                        mint,
                      ),
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select date and time"),
                            ),
                          );
                          return;
                        }

                        final client = ClientModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                        );

                        final appointment = AppointmentModel(
                          clientId: client.id,
                          service: selectedService!,
                          staffMember: selectedStaff!,
                          dateTime: DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          ),
                          notes: notesController.text.trim(),
                        );

                        context.read<AppointmentCubit>().createAppointment(
                          appointment,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mint,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Book Appointment",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600));

  InputDecoration _inputDecoration(String hint, Color mint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: mint),
      ),
    );
  }

  Widget _dateTimeField({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    String? value,
  }) {
    const mint = Color(0xFFAEC6C1);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mint),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? label,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            Icon(icon, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
