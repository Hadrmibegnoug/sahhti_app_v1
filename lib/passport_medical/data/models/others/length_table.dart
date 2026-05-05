import 'package:equatable/equatable.dart';

class LengthTableModel extends Equatable {
  final int allergiesCount;
  final int prescriptionCount;
  final int vaccinationCount;
  final int appointementCount;
  const LengthTableModel({
    required this.allergiesCount,
    required this.prescriptionCount,
    required this.vaccinationCount,
    required this.appointementCount,
  });
  @override
  List<Object?> get props => [
    allergiesCount,
    prescriptionCount,
    vaccinationCount,
    appointementCount,
  ];

  factory LengthTableModel.fromJson(Map<String, dynamic> json) {
    return LengthTableModel(
      allergiesCount: json['allergies_count'] as int,
      prescriptionCount: json['prescription_count'] as int,
      vaccinationCount: json['vaccination_count'] as int,
      appointementCount: json['appointement_count'] as int,
    );
  }
}
