import 'package:equatable/equatable.dart';

class PatientVaccinationsModel extends Equatable {
  final int patientId;
  final String vaccineName;
  final int dosesReceived;
  final int dosesRequired;
  final String status;

  const PatientVaccinationsModel({
    required this.patientId,
    required this.vaccineName,
    required this.dosesReceived,
    required this.dosesRequired,
    required this.status,
  });

  // Calculé localement — pas besoin de Supabase
  bool get estComplet => status == 'completed';

  double get progression =>
      dosesRequired > 0 ? dosesReceived / dosesRequired : 0.0;

  factory PatientVaccinationsModel.fromJson(Map<String, dynamic> json) {
    return PatientVaccinationsModel(
      patientId: json['patient_id'],
      vaccineName: json['vaccine_name'],
      dosesReceived: json['doses_received'],
      dosesRequired: json['doses_required'],
      status: json['status'],
    );
  }

  @override
  List<Object?> get props => [
    patientId,
    vaccineName,
    dosesReceived,
    dosesRequired,
    status,
  ];
}
