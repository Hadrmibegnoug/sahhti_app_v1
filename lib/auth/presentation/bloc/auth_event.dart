// auth/presentation/bloc/auth_event.dart

import 'package:equatable/equatable.dart';

import '../../data/models/registry_patient_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

// NNI
class NniSaisi extends AuthEvent {
  final String nni;
  const NniSaisi(this.nni);
  @override
  List<Object> get props => [nni];
}

// Inscription
class InscriptionDemandee extends AuthEvent {
  final RegistryPatientModel patient;
  final String telephone;
  final String pin;
  const InscriptionDemandee({
    required this.patient,
    required this.telephone,
    required this.pin,
  });
  @override
  List<Object> get props => [telephone, pin];
}

// OTP
class OtpInscriptionVerifie extends AuthEvent {
  final String telephone;
  final String otpCode;
  final String pin;
  final RegistryPatientModel patient;
  const OtpInscriptionVerifie({
    required this.telephone,
    required this.otpCode,
    required this.pin,
    required this.patient,
  });
  @override
  List<Object> get props => [telephone, otpCode];
}

class OtpRenvoye extends AuthEvent {
  final String telephone;
  const OtpRenvoye(this.telephone);
  @override
  List<Object> get props => [telephone];
}

// Connexion
class ConnexionDemandee extends AuthEvent {
  final String telephone;
  final String pin;
  const ConnexionDemandee({required this.telephone, required this.pin});
  @override
  List<Object> get props => [telephone, pin];
}

// Déconnexion
class DeconnexionDemandee extends AuthEvent {}

// ← NOUVEAUX : gestion clavier PIN dans le BLoC

// Initialiser le clavier PIN (inscription)
class PinInscriptionInitialise extends AuthEvent {}

// Initialiser le clavier PIN (connexion)
class PinConnexionInitialise extends AuthEvent {}

// Appuyer sur un chiffre
class PinChiffreAjoute extends AuthEvent {
  final String chiffre;
  const PinChiffreAjoute(this.chiffre);
  @override
  List<Object> get props => [chiffre];
}

// Appuyer sur effacer
class PinChiffreSupprime extends AuthEvent {}
