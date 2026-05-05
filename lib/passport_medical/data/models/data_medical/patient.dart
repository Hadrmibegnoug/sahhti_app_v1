import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  final int patientId;
  final String firstName;
  final String lastName;
  final String nni;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodType;
  final String phone;
  final String address;
  final String treatingDoctorId;
  final String pin;
  final String qrToken;

  const PatientModel({
    required this.firstName,
    required this.lastName,
    required this.nni,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.phone,
    required this.address,
    required this.treatingDoctorId,
    this.pin = '',
    this.qrToken = '',
    required this.patientId,
  });

  PatientModel copyWith({
    String? firstName,
    String? lastName,
    String? nni,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    String? phone,
    String? address,
    String? userId,
    String? treatingDoctorId,
    String? pin,
    String? qrToken,
    int? patientId,
  }) {
    return PatientModel(
      patientId: patientId ?? this.patientId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nni: nni ?? this.nni,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      treatingDoctorId: treatingDoctorId ?? this.treatingDoctorId,
      pin: pin ?? this.pin,
      qrToken: qrToken ?? this.qrToken,
    );
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      patientId: json['patient_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      nni: json['nni'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      gender: json['gender'],
      bloodType: json['blood_type'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      treatingDoctorId: json['treating_doctor_id']?.toString() ?? '',
      pin: json['pin'] ?? '',
      qrToken: json['qr_token'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    nni,
    dateOfBirth,
    gender,
    bloodType,
    phone,
    address,
    treatingDoctorId,
    pin,
    qrToken,
  ];
}
