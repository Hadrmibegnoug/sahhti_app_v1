import 'package:equatable/equatable.dart';

class MedicalRecordsModel extends Equatable {
  final String patientId;
  final String title;
  final String recordType;
  final String notes;
  final String content;
  final String doctorId;
  final String establishmentId;

  const MedicalRecordsModel({
    required this.patientId,
    required this.title,
    required this.recordType,
    required this.notes,
    required this.content,
    required this.doctorId,
    required this.establishmentId,
  });

  @override
  List<Object?> get props => [
    patientId,
    title,
    recordType,
    notes,
    content,
    doctorId,
    establishmentId,
  ];
}
