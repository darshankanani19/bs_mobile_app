part of 'appointment_cubit.dart';

class AppointmentState extends Equatable {
  final FormzSubmissionStatus createStatus;
  final FormzSubmissionStatus updateStatus;
  final FormzSubmissionStatus deleteStatus;
  final String? errorMessage;

  const AppointmentState({
    this.createStatus = FormzSubmissionStatus.initial,
    this.updateStatus = FormzSubmissionStatus.initial,
    this.deleteStatus = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  AppointmentState copyWith({
    FormzSubmissionStatus? createStatus,
    FormzSubmissionStatus? updateStatus,
    FormzSubmissionStatus? deleteStatus,
    String? errorMessage,
  }) {
    return AppointmentState(
      createStatus: createStatus ?? this.createStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    createStatus,
    updateStatus,
    deleteStatus,
    errorMessage,
  ];
}
