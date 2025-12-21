import 'package:equatable/equatable.dart';
import 'package:beauty_salon/features/appointments/models/client_model.dart';

enum AppointmentStatus { initial, loading, success, failure }

class AppointmentState extends Equatable {
  final AppointmentStatus status;
  final String? errorMessage;
  final ClientModel? selectedClient;
  final List<ClientModel> suggestions;
  final List<String> services;
  final List<String> staffMembers;

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.errorMessage,
    this.selectedClient,
    this.suggestions = const [],
    this.services = const [],
    this.staffMembers = const [],
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
    String? errorMessage,
    ClientModel? selectedClient,
    List<ClientModel>? suggestions,
    List<String>? services,
    List<String>? staffMembers,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedClient: selectedClient ?? this.selectedClient,
      suggestions: suggestions ?? this.suggestions,
      services: services ?? this.services,
      staffMembers: staffMembers ?? this.staffMembers,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    selectedClient,
    suggestions,
    services,
    staffMembers,
  ];
}
