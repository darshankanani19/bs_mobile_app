import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import 'package:beauty_salon/core/utils/app_colors.dart';
import 'package:beauty_salon/core/utils/app_strings.dart';
import 'package:beauty_salon/core/utils/route_names.dart';
import 'package:beauty_salon/core/utils/validation_helper.dart';
import 'package:beauty_salon/features/authentication/cubit/authentication_cubit.dart';
import 'package:beauty_salon/features/authentication/models/signup_request_model.dart';
import 'package:beauty_salon/features/authentication/view/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedUserType = "owner"; // Default selected type

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (prev, curr) => prev.signupStatus != curr.signupStatus,
      listener: (context, state) {
        if (state.signupStatus == FormzSubmissionStatus.success) {
          Flushbar(
            message: AppStrings.signupSuccessMessage,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.TOP,
            onStatusChanged: (status) {
              if (status == FlushbarStatus.DISMISSED) {
                context.go(Routes.login);
              }
            },
          ).show(context);
        } else if (state.signupStatus == FormzSubmissionStatus.failure) {
          Flushbar(
            message: state.errorMessage ?? AppStrings.signupFailedMessage,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.error_outline, color: Colors.white),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.TOP,
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
                    child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        final isLoading = state.signupStatus ==
                            FormzSubmissionStatus.inProgress;

                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          Text(
                            "Sign Up",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ===== User Type Dropdown =====
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Type of User",
                              ),
                              value: selectedUserType,
                              items: const [
                                DropdownMenuItem(
                                  value: "owner",
                                  child: Text("owner"),
                                ),
                                DropdownMenuItem(
                                  value: "staff",
                                  child: Text("staff"),
                                ),
                              ],
                              onChanged: isLoading
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        setState(() => selectedUserType = val);
                                      }
                                    },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ===== First Name =====
                          CustomInputField(
                            controller: firstNameController,
                            label: "First Name",
                            hintText: "Enter your first name",
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            validator: ValidationHelper.validateName,
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // ===== Last Name =====
                          CustomInputField(
                            controller: lastNameController,
                            label: "Last Name",
                            hintText: "Enter your last name",
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            validator: ValidationHelper.validateName,
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // ===== Email =====
                          CustomInputField(
                            controller: emailController,
                            label: "Email",
                            hintText: "Enter your email",
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            validator: ValidationHelper.validateEmail,
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),

                          // ===== Password =====
                          CustomInputField(
                            controller: passwordController,
                            label: "Password",
                            hintText: "Enter your password",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            obscureText: true,
                            validator: ValidationHelper.validatePassword,
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 20),

                          // ===== SignUp Button =====
                          GestureDetector(
                            onTap: () {
                              if (isLoading) return;
                              if (_formKey.currentState!.validate()) {
                                final signupModel = SignUpRequestModel(
                                  firstName: firstNameController.text
                                      .trim(),
                                  lastName: lastNameController.text.trim(),
                                  userType: selectedUserType,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                                context.read<AuthenticationCubit>().signup(
                                  signupModel,
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
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black87,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ===== Already Have Account =====
                          GestureDetector(
                            onTap: isLoading ? null : () => context.go(Routes.login),
                            child: const Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(color: Colors.black54),
                                children: [
                                  TextSpan(
                                    text: "[Login]",
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
                    );
                  },
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
