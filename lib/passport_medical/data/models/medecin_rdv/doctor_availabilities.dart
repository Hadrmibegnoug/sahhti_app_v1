import 'package:equatable/equatable.dart';

class DoctorAvailabilitiesModel extends Equatable {
  final int doctorId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int slotDurationMinutes;

  const DoctorAvailabilitiesModel({
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.slotDurationMinutes,
  });

  factory DoctorAvailabilitiesModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilitiesModel(
      doctorId: json['doctor_id'] as int,
      dayOfWeek: json['day_of_week'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slotDurationMinutes: json['slot_duration_minutes'] as int,
    );
  }

  @override
  List<Object?> get props => [
    doctorId,
    dayOfWeek,
    startTime,
    endTime,
    slotDurationMinutes,
  ];
}
