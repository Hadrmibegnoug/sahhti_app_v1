import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

// Charger le profil au démarrage de la page
class ProfileCharge extends ProfileEvent {}

// Déconnexion
class ProfileDeconnexionDemandee extends ProfileEvent {}

// Modifier les données personnelles
class ProfileMisAJour extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String? bloodType;

  const ProfileMisAJour({
    required this.firstName,
    required this.lastName,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.bloodType,
  });

  @override
  List<Object?> get props => [firstName, lastName, phone];
}

// Changer le PIN
class ProfilePinChange extends ProfileEvent {
  final String ancienPin;
  final String nouveauPin;
  const ProfilePinChange({required this.ancienPin, required this.nouveauPin});
  @override
  List<Object> get props => [ancienPin, nouveauPin];
}

class ProfileRafraichi extends ProfileEvent {
  const ProfileRafraichi();
}
