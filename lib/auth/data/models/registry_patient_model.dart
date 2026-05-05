import 'package:equatable/equatable.dart';

class RegistryPatientModel extends Equatable {
  final int    id;
  final String nni;
  final String firstName;
  final String lastName;
  final String? dateOfBirth;
  final String? gender;
  final String? address;

  const RegistryPatientModel({
    required this.id,
    required this.nni,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
    this.address,
  });

  String get nomComplet => '$firstName $lastName';

  factory RegistryPatientModel.fromJson(Map<String, dynamic> json) {
    return RegistryPatientModel(
      id:          json['id']          as int,
      nni:         json['nni']         as String,
      firstName:   json['first_name']  as String,
      lastName:    json['last_name']   as String,
      dateOfBirth: json['date_of_birth'] as String?,
      gender:      json['gender']      as String?,
      address:     json['address']     as String?,
    );
  }

  @override
  List<Object?> get props => [id, nni];
}