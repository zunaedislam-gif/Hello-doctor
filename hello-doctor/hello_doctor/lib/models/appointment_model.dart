class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorDegrees;
  final String doctorSpecialty;
  final String date;
  final String timeSlot;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'
  final double consultationFee;
  final double vat;
  final double platformFee;
  final double totalAmount;
  final String paymentMethod;
  final DateTime createdAt;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorDegrees,
    required this.doctorSpecialty,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.consultationFee,
    required this.vat,
    required this.platformFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
  });
}
