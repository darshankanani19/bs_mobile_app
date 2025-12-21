import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:beauty_salon/core/utils/app_colors.dart';
import 'package:beauty_salon/core/utils/route_names.dart';
import 'package:beauty_salon/core/utils/validation_helper.dart';
import 'package:beauty_salon/features/authentication/cubit/authentication_cubit.dart';
import 'package:beauty_salon/features/authentication/models/forgot_password_request_model.dart';
import 'package:beauty_salon/features/authentication/view/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (p, c) => p.forgotPasswordStatus != c.forgotPasswordStatus,
      listener: (context, state) {
        if (state.forgotPasswordStatus == FormzSubmissionStatus.success) {
          Flushbar(
            message: "Reset link sent! Please check your email.",
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          ).show(context).then((_) {
            context.go(Routes.welcome);
          });
        } else if (state.forgotPasswordStatus ==
            FormzSubmissionStatus.failure) {
          Flushbar(
            message: state.errorMessage ?? "Something went wrong.",
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.error_outline, color: Colors.white),
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.mint,
        body: SafeArea(
          child: Column(
            children: [
              // ===== Header Section =====
              Container(
                height: size.height * 0.22,
                width: double.infinity,
                color: AppColors.mint,
                child: Stack(
                  children: [
                    Positioned(
                      left: 24,
                      top: 40,
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Beauty",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const TextSpan(text: "\n"), // new line for Salon
                            TextSpan(
                              text: "Salon",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 2,
                                color: const Color(0xFF4E4E4E),
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 6,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 20,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== White Rounded Panel =====
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(80),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Forgot Password",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ===== Email Field =====
                          CustomInputField(
                            label: "Email Address",
                            controller: emailController,
                            hintText: "Enter your registered email",
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            validator: ValidationHelper.validateEmail,
                          ),
                          const SizedBox(height: 24),

                          // ===== Submit Button =====
                          BlocBuilder<AuthenticationCubit, AuthenticationState>(
                            builder: (context, state) {
                              final isLoading =
                                  state.forgotPasswordStatus ==
                                  FormzSubmissionStatus.inProgress;

                              return GestureDetector(
                                onTap: () {
                                  if (isLoading) return;
                                  if (_formKey.currentState!.validate()) {
                                    final payload = ForgotPasswordRequestModel(
                                      email: emailController.text.trim(),
                                    );
                                    context
                                        .read<AuthenticationCubit>()
                                        .forgotPassword(payload);
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.mint,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Send Reset Link",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black87,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // ===== Back to Login =====
                          GestureDetector(
                            onTap: () => context.push(Routes.login),
                            child: Container(
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.mint,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ===== Sign Up =====
                          GestureDetector(
                            onTap: () => context.push(Routes.signup),
                            child: const Text.rich(
                              TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(color: Colors.black54),
                                children: [
                                  TextSpan(
                                    text: "[Sign Up]",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
