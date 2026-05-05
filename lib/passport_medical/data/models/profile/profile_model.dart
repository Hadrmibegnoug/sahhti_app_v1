import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String nni;
  final String phone;
  final String gender;
  final DateTime dateOfBirth;
  final String bloodType;
  final String? treatingDoctorId;

  const ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nni,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.bloodType,
    this.treatingDoctorId,
  });

  String get nomComplet => '$firstName $lastName';

  String get initiaux {
    final parts = nomComplet.split(' ');
    return parts.map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['patient_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      nni: json['nni'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      bloodType: json['blood_type'] as String? ?? 'Inconnu',
      treatingDoctorId: json['treating_doctor_id']?.toString() ?? '',
    );
  }

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? gender,
    DateTime? dateOfBirth,
    String? bloodType,
  }) {
    return ProfileModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nni: nni,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodType: bloodType ?? this.bloodType,
      treatingDoctorId: treatingDoctorId,
    );
  }

  @override
  List<Object?> get props => [id, nni, phone];
}
