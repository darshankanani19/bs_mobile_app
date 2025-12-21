import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:beauty_salon/core/helper/storage_helper.dart';
import 'package:beauty_salon/core/network/api_result_service.dart';
import 'package:beauty_salon/features/authentication/models/forgot_password_request_model.dart';
import 'package:beauty_salon/features/authentication/models/forgot_password_response_model.dart';
import 'package:beauty_salon/features/authentication/models/get_user_model.dart';
import 'package:beauty_salon/features/authentication/models/login_data_model.dart';
import 'package:beauty_salon/features/authentication/models/reset_password_request_model.dart';
import 'package:beauty_salon/features/authentication/models/signup_request_model.dart';
import 'package:beauty_salon/features/authentication/repo/authentication_repo.dart';
// import 'package:mavemate/core/utils/token_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepo authenticationRepo;
  // Constructor to initialize the AuthenticationRepo
  AuthenticationCubit({required this.authenticationRepo})
    : super(AuthenticationState());

  // Method to handle signup
  // Future<void> signup(SignUpRequestModel payload) async {
  //   try {
  //     emit(state.copyWith(signupStatus: FormzSubmissionStatus.inProgress));
  //     debugPrint('📤 Signup Payload: ${payload.toJson()}');
  //     RepoResult response = await authenticationRepo.signup(
  //
  //       payload: payload.toJson(),
  //     );
  //
  //     if (response is RepoSuccess) {
  //       debugPrint('✅ Signup API Success: ${response.data}');
  //       LoginData loginData = response.data;
  //       debugPrint('Signup successful: ${loginData.toMap()}');
  //       emit(state.copyWith(signupStatus: FormzSubmissionStatus.success));
  //     } else if (response is RepoFailure) {
  //       emit(state.copyWith(
  //         signupStatus: FormzSubmissionStatus.failure,
  //         errorMessage: response.error,
  //       ));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       signupStatus: FormzSubmissionStatus.failure,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }
  Future<void> signup(SignUpRequestModel payload) async {
    try {
      emit(state.copyWith(signupStatus: FormzSubmissionStatus.inProgress));

      RepoResult response = await authenticationRepo.signup(
        payload: payload.toJson(),
      );

      if (response is RepoSuccess) {
        // ✅ This is a plain map, not LoginData
        debugPrint('Signup successful: ${response.data}');

        emit(state.copyWith(signupStatus: FormzSubmissionStatus.success));
      } else if (response is RepoFailure) {
        emit(
          state.copyWith(
            signupStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          signupStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Future<void> login(Map<String, dynamic> payload) async {
  //   try {
  //     emit(state.copyWith(loginStatus: FormzSubmissionStatus.inProgress));
  //
  //     RepoResult response = await authenticationRepo.login(payload: payload);
  //
  //     if (response is RepoSuccess<LoginResponse>) {
  //
  //       final loginResponse = response.data;
  //       LoginData? loginData = loginResponse?.data;
  //
  //
  //       debugPrint('Login successful: ${loginData?.toMap()}');
  //       if (loginData != null) {
  //         await StorageHelper.saveLoginData(loginData);
  //
  //         debugPrint('Login successful: ${loginData.toMap()}');
  //         emit(state.copyWith(loginStatus: FormzSubmissionStatus.success));
  //       } else {
  //         emit(state.copyWith(
  //           loginStatus: FormzSubmissionStatus.failure,
  //           errorMessage: "Login failed: empty data",
  //         ));
  //       }
  //     } else if (response is RepoFailure) {
  //       emit(state.copyWith(
  //         loginStatus: FormzSubmissionStatus.failure,
  //         errorMessage: response.error,
  //       ));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(
  //       loginStatus: FormzSubmissionStatus.failure,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }
  Future<void> login(Map<String, dynamic> payload) async {
    try {
      emit(state.copyWith(loginStatus: FormzSubmissionStatus.inProgress));

      RepoResult response = await authenticationRepo.login(payload: payload);

      if (response is RepoSuccess<LoginResponse>) {
        final loginResponse = response.data;
        LoginData? loginData = loginResponse?.data;

        if (loginData != null) {
          await StorageHelper.saveLoginData(loginData);

          debugPrint('Login successful: ${loginData.toMap()}');
          emit(state.copyWith(loginStatus: FormzSubmissionStatus.success));
        } else {
          emit(
            state.copyWith(
              loginStatus: FormzSubmissionStatus.failure,
              errorMessage: "Login failed: Empty response data",
            ),
          );
        }
      } else if (response is RepoFailure) {
        emit(
          state.copyWith(
            loginStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: FormzSubmissionStatus.failure,
          errorMessage: "Unexpected error: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequestModel requestModel) async {
    try {
      emit(
        state.copyWith(
          forgotPasswordStatus: FormzSubmissionStatus.inProgress,
          errorMessage: null,
        ),
      );

      RepoResult response = await authenticationRepo.forgotPassword(
        payload: requestModel.toJson(),
      );

      if (response is RepoSuccess<ForgotPasswordResponseModel>) {
        final forgotResponse = response.data;

        if (forgotResponse != null) {
          debugPrint('Forgot password response: ${forgotResponse.toJson()}');

          emit(
            state.copyWith(
              forgotPasswordStatus: FormzSubmissionStatus.success,
              errorMessage: forgotResponse.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              forgotPasswordStatus: FormzSubmissionStatus.failure,
              errorMessage: "Forgot password failed: Empty response data",
            ),
          );
        }
      } else if (response is RepoFailure) {
        emit(
          state.copyWith(
            forgotPasswordStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          forgotPasswordStatus: FormzSubmissionStatus.failure,
          errorMessage: "Unexpected error: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> resetPassword(ResetPasswordRequestModel requestModel) async {
    try {
      emit(
        state.copyWith(
          resetPasswordStatus: FormzSubmissionStatus.inProgress,
          errorMessage: null,
        ),
      );

      RepoResult response = await authenticationRepo.resetPassword(
        payload: requestModel.toJson(),
      );

      if (response is RepoSuccess) {
        final responseData = response.data;

        debugPrint('Reset password successful: $responseData');

        emit(
          state.copyWith(
            resetPasswordStatus: FormzSubmissionStatus.success,
            errorMessage: "Password reset successful",
          ),
        );
      } else if (response is RepoFailure) {
        emit(
          state.copyWith(
            resetPasswordStatus: FormzSubmissionStatus.failure,
            errorMessage: response.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          resetPasswordStatus: FormzSubmissionStatus.failure,
          errorMessage: "Unexpected error: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> fetchUser() async {
    emit(state.copyWith(userStatus: FormzSubmissionStatus.inProgress));

    try {
      final result = await authenticationRepo.getUser();

      if (result is RepoSuccess<Getusermodel>) {
        // final userModel = result.data;
        emit(
          state.copyWith(
            userStatus: FormzSubmissionStatus.success,
            user: result.data, // 👈 store Data, not whole Getusermodel
          ),
        );
      } else if (result is RepoFailure) {
        emit(
          state.copyWith(
            userStatus: FormzSubmissionStatus.failure,
            errorMessage: (result as RepoFailure).error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          userStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await authenticationRepo.logout();

      // Clear local storage/session
      await StorageHelper.logout();

      // Emit logout success and clear user
      emit(
        AuthenticationState(
          logoutStatus: FormzSubmissionStatus.success,
          user: null,
        ),
      );

      // Reset logoutStatus so next logout works normally
      emit(
        AuthenticationState(
          logoutStatus: FormzSubmissionStatus.initial,
          user: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          logoutStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );

      emit(state.copyWith(logoutStatus: FormzSubmissionStatus.initial));
    }
  }

  void clearUser() {
    emit(AuthenticationState()); // resets everything to initial state
  }
}
