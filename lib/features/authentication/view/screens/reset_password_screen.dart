import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:beauty_salon/core/utils/app_assets.dart';
import 'package:beauty_salon/core/utils/app_colors.dart';

import 'package:beauty_salon/core/utils/app_strings.dart';
import 'package:beauty_salon/core/utils/validation_helper.dart';
import 'package:beauty_salon/features/authentication/cubit/authentication_cubit.dart';
// import 'package:beauty_salon/features/authentication/model/reset_password_request_model.dart';
import 'package:beauty_salon/features/authentication/models/reset_password_request_model.dart';
import 'package:beauty_salon/features/authentication/view/widgets/custom_button.dart';
import 'package:beauty_salon/features/authentication/view/widgets/custom_text_field.dart';
import 'package:another_flushbar/flushbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          AppStrings.resetPassword,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (prev, curr) =>
            prev.resetPasswordStatus != curr.resetPasswordStatus,
        listener: (context, state) {
          if (state.resetPasswordStatus.isSuccess) {
            Flushbar(
              message: "Password reset successful",
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
              icon: Icon(Icons.check_circle, color: Colors.white),
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              flushbarPosition: FlushbarPosition.TOP,
              onStatusChanged: (status) {
                if (status == FlushbarStatus.DISMISSED) {
                  context.go('/login');
                }
              },
            ).show(context);
            // Navigate to login or desired route
          } else if (state.resetPasswordStatus.isFailure) {
            Flushbar(
              message: state.errorMessage ?? "Reset failed",
              duration: Duration(seconds: 3),
              backgroundColor: Colors.redAccent,
              icon: Icon(Icons.error_outline, color: Colors.white),
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    AppAssets.splashLogo,
                    height: 150,
                    width: 150,
                  ),
                ),

                const SizedBox(height: 30),
                CustomInputField(
                  label: AppStrings.emailAddress,
                  controller: _emailController,
                  hintText: AppStrings.enterEmail,
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  validator:
                      ValidationHelper.validateEmail, // ✅ Shared validator
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: AppStrings.otp,
                  hintText: AppStrings.enterOtp,
                  controller: _otpController,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  label: AppStrings.newPassword,
                  controller: _newPasswordController,
                  hintText: AppStrings.newPassword,
                  obscureText: true,
                  validator: ValidationHelper.validatePassword,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  label: AppStrings.confirmPassword,
                  controller: _confirmPasswordController,
                  hintText: AppStrings.confirmPassword,
                  obscureText: true,
                  validator: (value) =>
                      ValidationHelper.validateConfirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthenticationCubit, AuthenticationState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: AppStrings.resetPassword,
                      isLoading: state.resetPasswordStatus.isInProgress,
                      onTap: () {
                        final email = _emailController.text.trim();
                        final otp = _otpController.text.trim();
                        final newPassword = _newPasswordController.text;
                        final confirmPassword = _confirmPasswordController.text;

                        if (email.isEmpty ||
                            otp.isEmpty ||
                            newPassword.isEmpty ||
                            confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("All fields are required"),
                            ),
                          );
                          return;
                        }

                        if (newPassword != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                            ),
                          );
                          return;
                        }

                        final request = ResetPasswordRequestModel(
                          email: email,
                          otp: otp,
                          newPassword: newPassword,
                        );

                        context.read<AuthenticationCubit>().resetPassword(
                          request,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
