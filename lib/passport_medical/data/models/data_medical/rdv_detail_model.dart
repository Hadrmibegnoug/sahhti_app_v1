import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RdvDetailModel extends Equatable {
  final int id;
  final int patientId;
  final int doctorId;
  final String medecinNom;
  final String medecinSpecialite;
  final DateTime appointmentDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;
  final String type;
  final String reason;

  const RdvDetailModel({
    required this.id,
    required this.medecinNom,
    required this.medecinSpecialite,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.type,
    required this.reason,
    required this.patientId,
    required this.doctorId,
  });

  // Calculé localement — pas de Supabase
  bool get estAVenir => appointmentDate.isAfter(DateTime.now());

  String get startTimeFormatted =>
      '${startTime.hour.toString().padLeft(2, '0')}:'
      '${startTime.minute.toString().padLeft(2, '0')}';

  String get endTimeFormatted =>
      '${endTime.hour.toString().padLeft(2, '0')}:'
      '${endTime.minute.toString().padLeft(2, '0')}';
  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory RdvDetailModel.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctors'] as Map<String, dynamic>? ?? {};

    return RdvDetailModel(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      doctorId: json['doctor_id'] as int,

      medecinNom:
          'Dr. ${doctor['first_name'] ?? ''} ${doctor['last_name'] ?? ''}',

      medecinSpecialite: doctor['specialty']?.toString() ?? '',

      appointmentDate: DateTime.parse(json['appointment_date'].toString()),

      startTime: _parseTime(json['start_time'].toString()),
      endTime: _parseTime(json['end_time'].toString()),

      status: json['status']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
  @override
  List<Object?> get props => [
    medecinNom,
    medecinSpecialite,
    appointmentDate,
    startTime,
    endTime,
    status,
    type,
    reason,
  ];
}
