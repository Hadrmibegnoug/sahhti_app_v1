import 'package:equatable/equatable.dart';

class PrescriptionDispensationsModel extends Equatable {
  final String prescriptionId;
  final String patientId;
  final String dispensedBy;
  final String quantityDispensed;

  const PrescriptionDispensationsModel({
    required this.prescriptionId,
    required this.patientId,
    required this.dispensedBy,
    required this.quantityDispensed,
  });

  @override
  List<Object?> get props => [
    prescriptionId,
    patientId,
    dispensedBy,
    quantityDispensed,
  ];
}
