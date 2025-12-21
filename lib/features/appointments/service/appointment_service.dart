class AppointmentService {
  Future<List<String>> fetchServices() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ['Haircut', 'Facial', 'Manicure', 'Pedicure', 'Massage'];
  }

  Future<List<String>> fetchStaffMembers() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ['Ava Smith', 'John Doe', 'Sophia Patel', 'David Khan'];
  }

  Future<void> createAppointment(Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
