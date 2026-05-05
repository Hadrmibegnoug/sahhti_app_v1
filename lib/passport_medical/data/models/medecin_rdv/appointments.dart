import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppointmentsModel extends Equatable {
  final int patientId;
  final int doctorId;
  final DateTime appointmentDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;
  final String type;
  final String reason;
  final bool bookedByPatient;

  const AppointmentsModel({
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.status,
    required this.type,
    required this.reason,
    required this.bookedByPatient,
    required this.startTime,
    required this.endTime,
  });

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory AppointmentsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentsModel(
      patientId: json['patient_id'] as int,
      doctorId: json['doctor_id'] as int,
      appointmentDate: DateTime.parse(json["appointment_date"] as String),
      startTime: _parseTime(json["start_time"].toString()),
      endTime: _parseTime(json["end_time"].toString()),
      status: json["status"] as String,
      type: json["type"] as String,
      reason: json["reason"] as String? ?? '',
      bookedByPatient: json["booked_by_patient"],
    );
  }

  @override
  List<Object?> get props => [
    patientId,
    doctorId,
    appointmentDate,
    status,
    type,
    reason,
    bookedByPatient,
  ];
}
