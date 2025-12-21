import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:beauty_salon/core/utils/app_colors.dart';
import 'package:beauty_salon/core/utils/route_names.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                  // Left Logo
                  Positioned(
                    left: 24,
                    top: 40,
                    child: Image.asset(
                      'assets/images/logo.png', // your logo
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Right Welcome Text
                  Positioned(
                    right: 24,
                    top: 70,
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Welcome To\n",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: "Beauty Salon",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 2,
                              color: Color(0xFF3E3E3E),
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
                    ),
                  ),
                ],
              ),
            ),

            // ===== White Rounded Body Section =====
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    // ===== Title =====
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Book Your\n",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: "Appointment",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF3E3E3E),
                              letterSpacing: 1.5,
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
                    ),

                    const SizedBox(height: 40),

                    // ===== Login Button =====
                    GestureDetector(
                      onTap: () => context.push(Routes.login),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        height: 48,
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

                    const SizedBox(height: 20),

                    // ===== Register Button =====
                    GestureDetector(
                      onTap: () => context.push(Routes.signup),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ===== Footer Text =====
                    const Text(
                      "Schedule Your Appointment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
