import 'package:equatable/equatable.dart';

class PatientPrescriptionsModel extends Equatable {
  final int patientId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  const PatientPrescriptionsModel({
    required this.patientId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  PatientPrescriptionsModel copyWith({
    int? patientId,
    String? medicationName,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return PatientPrescriptionsModel(
      patientId: patientId ?? this.patientId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  factory PatientPrescriptionsModel.fromJson(Map<String, dynamic> json) {
    return PatientPrescriptionsModel(
      patientId: json['patient_id'],
      medicationName: json['medication_name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["end_date"]),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['medication_name'] = medicationName;
    data['dosage'] = dosage;
    data['frequency'] = frequency;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    return data;
  }

  @override
  List<Object?> get props => [
    patientId,
    medicationName,
    dosage,
    frequency,
    startDate,
    endDate,
    status,
  ];
}
