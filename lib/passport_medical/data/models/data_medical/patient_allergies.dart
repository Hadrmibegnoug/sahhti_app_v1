import 'package:equatable/equatable.dart';

class PatientAllergiesModel extends Equatable {
  final int id;
  final int patientId;
  final String allergen;
  final String severity;
  const PatientAllergiesModel({
    required this.patientId,
    required this.allergen,
    required this.severity,
    required this.id,
  });
  @override
  List<Object?> get props => [patientId, allergen, severity];
  PatientAllergiesModel copyWith({
    int? id,
    int? patientId,
    String? allergen,
    String? severity,
  }) {
    return PatientAllergiesModel(
      patientId: patientId ?? this.patientId,
      allergen: allergen ?? this.allergen,
      severity: severity ?? this.severity,
      id: id ?? this.id,
    );
  }

  factory PatientAllergiesModel.fromJson(Map<String, dynamic> json) {
    return PatientAllergiesModel(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      allergen: json['allergen'] as String,
      severity: json['severity'] as String,
    );
  }
}
