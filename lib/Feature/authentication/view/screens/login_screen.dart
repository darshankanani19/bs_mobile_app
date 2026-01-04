import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import 'package:bs/Core/Util/app_colors.dart';
import 'package:bs/Core/Util/app_strings.dart';
import 'package:bs/Core/Util/route_names.dart';
import 'package:bs/Core/Util/validation_helper.dart';
import 'package:bs/Feature/authentication/cubit/authentication_cubit.dart';
import 'package:bs/Feature/authentication/models/login_request_model.dart';
import 'package:bs/Feature/authentication/view/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const textColor = Colors.black;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (prev, curr) => prev.loginStatus != curr.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == FormzSubmissionStatus.success) {
          context.go(Routes.home);
        } else if (state.loginStatus == FormzSubmissionStatus.failure &&
            state.errorMessage != null) {
          Flushbar(
            message: state.errorMessage!,
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
                height: size.height * 0.25,
                width: double.infinity,
                color: AppColors.mint,
                child: Stack(
                  children: [
                    // ---- Title (Beauty Salon)
                    Positioned(
                      left: 24,
                      top: 40,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontFamily: 'Roboto'),
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
                            TextSpan(text: "\n"),
                            TextSpan(
                              text: "Salon",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 2,
                                color: Color(0xFF4E4E4E),
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

                    // ---- Logo Top Right ----
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
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== White Body Section (Rounded Top-Right) =====
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ===== Username Field =====
                          CustomInputField(
                            label: "User Name",
                            controller: emailController,
                            hintText: "Enter your user name",
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            validator: ValidationHelper.validateEmail,
                          ),
                          const SizedBox(height: 16),

                          // ===== Password Field =====
                          CustomInputField(
                            label: "Password",
                            controller: passwordController,
                            hintText: "Enter your password",
                            obscureText: true,
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // ===== Forgot Password =====
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  context.push(Routes.forgotPassword),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ===== Login Button =====
                          BlocBuilder<AuthenticationCubit, AuthenticationState>(
                            builder: (context, state) {
                              final isLoading =
                                  state.loginStatus ==
                                  FormzSubmissionStatus.inProgress;

                              return GestureDetector(
                                onTap: () {
                                  if (isLoading) return;
                                  if (_formKey.currentState!.validate()) {
                                    final payload = LoginRequestModel(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ).toJson();

                                    context.read<AuthenticationCubit>().login(
                                      payload,
                                    );
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
                                          "Login",
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

                          const SizedBox(height: 18),

                          // ===== SignUp Link =====
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
