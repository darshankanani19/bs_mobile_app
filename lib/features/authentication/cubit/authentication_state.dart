part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final FormzSubmissionStatus signupStatus;
  final FormzSubmissionStatus loginStatus;
  final FormzSubmissionStatus forgotPasswordStatus;
  final FormzSubmissionStatus verifyOtpStatus;
  final FormzSubmissionStatus resetPasswordStatus;
  final FormzSubmissionStatus logoutStatus; // Add this line

  /// 🔹 New fields for user
  final FormzSubmissionStatus userStatus;
  final Getusermodel? user;

  final String? errorMessage;

  const AuthenticationState({
    this.signupStatus = FormzSubmissionStatus.initial,
    this.loginStatus = FormzSubmissionStatus.initial,
    this.forgotPasswordStatus = FormzSubmissionStatus.initial,
    this.verifyOtpStatus = FormzSubmissionStatus.initial,
    this.resetPasswordStatus = FormzSubmissionStatus.initial,
    this.logoutStatus = FormzSubmissionStatus.initial, // Add this line
    this.userStatus = FormzSubmissionStatus.initial, // default
    this.user,
    this.errorMessage,
  });

  AuthenticationState copyWith({
    FormzSubmissionStatus? signupStatus,
    FormzSubmissionStatus? loginStatus,
    FormzSubmissionStatus? forgotPasswordStatus,
    FormzSubmissionStatus? verifyOtpStatus,
    FormzSubmissionStatus? resetPasswordStatus,
    FormzSubmissionStatus? logoutStatus, // Add this line
    FormzSubmissionStatus? userStatus,
    Getusermodel? user,
    String? errorMessage,
  }) {
    return AuthenticationState(
      signupStatus: signupStatus ?? this.signupStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus, // Add this line
      userStatus: userStatus ?? this.userStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    signupStatus,
    loginStatus,
    forgotPasswordStatus,
    verifyOtpStatus,
    resetPasswordStatus,
    logoutStatus, // Add this line
    userStatus,
    user,
    errorMessage,
  ];
}