import 'package:equatable/equatable.dart';

import '../../data/models/registry_patient_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthChargement extends AuthState {}

class AuthConnecte extends AuthState {}

class NniTrouve extends AuthState {
  final RegistryPatientModel patient;
  const NniTrouve(this.patient);
  @override
  List<Object> get props => [patient];
}

class OtpEnvoye extends AuthState {
  final String telephone;
  final String pin;
  final RegistryPatientModel patient;
  const OtpEnvoye({
    required this.telephone,
    required this.pin,
    required this.patient,
  });
  @override
  List<Object> get props => [telephone, pin];
}

class OtpRenvoyeChargement extends AuthState {}

// ← NOUVEAU : état du clavier PIN (inscription)
class PinSaisieState extends AuthState {
  final List<String> pin;
  final List<String> pinConfirmation;
  final bool etapeConfirmation;

  const PinSaisieState({
    this.pin = const [],
    this.pinConfirmation = const [],
    this.etapeConfirmation = false,
  });

  // La liste active selon l'étape
  List<String> get current => etapeConfirmation ? pinConfirmation : pin;

  // PIN complet
  bool get pinComplet => current.length == 4;

  // Les deux PIN correspondent
  bool get correspondent => pin.join() == pinConfirmation.join();

  PinSaisieState copyWith({
    List<String>? pin,
    List<String>? pinConfirmation,
    bool? etapeConfirmation,
  }) {
    return PinSaisieState(
      pin: pin ?? this.pin,
      pinConfirmation: pinConfirmation ?? this.pinConfirmation,
      etapeConfirmation: etapeConfirmation ?? this.etapeConfirmation,
    );
  }

  @override
  List<Object> get props => [pin, pinConfirmation, etapeConfirmation];
}

// ← NOUVEAU : état du clavier PIN (connexion)
class PinConnexionState extends AuthState {
  final List<String> pin;
  const PinConnexionState({this.pin = const []});
  bool get pinComplet => pin.length == 4;
  @override
  List<Object> get props => [pin];
}

class AuthErreur extends AuthState {
  final String message;
  const AuthErreur(this.message);
  @override
  List<Object> get props => [message];
}
