// medecin_bloc/medecin_state.dart

import 'package:equatable/equatable.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/appointments.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctor_availabilities.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctors.dart';

abstract class MedecinState extends Equatable {
  const MedecinState();
  @override
  List<Object?> get props => [];
}

class MedecinInitial extends MedecinState {}

class MedecinLoading extends MedecinState {}

class RdvEnCours extends MedecinState {}

class RdvSucces extends MedecinState {
  final AppointmentsModel rdv;
  const RdvSucces(this.rdv);
  @override
  List<Object> get props => [rdv];
}

class MedecinError extends MedecinState {
  final String message;
  const MedecinError({required this.message});
  @override
  List<Object> get props => [message];
}

class MedecinLoaded extends MedecinState {
  final List<DoctorsModel> tousLesdoctors;
  final List<DoctorsModel> medecinsFiltres;
  final String? specialityActive;
  final String searchQuery;

  // Détail médecin
  final DoctorsModel? medecinSelectionne;
  final List<DoctorAvailabilitiesModel> availibilities;
  final bool availibilitiesLoading;

  // ← NOUVEAU : disponibilité cliquée par le patient
  final DoctorAvailabilitiesModel? disponibiliteSelectionnee;

  // Type de consultation
  final String rdvType;

  const MedecinLoaded({
    required this.tousLesdoctors,
    required this.medecinsFiltres,
    this.specialityActive,
    this.searchQuery = '',
    this.medecinSelectionne,
    this.availibilities = const [],
    this.availibilitiesLoading = false,
    this.disponibiliteSelectionnee, // ← nouveau
    this.rdvType = 'consultation',
  });

  MedecinLoaded copyWith({
    List<DoctorsModel>? medecinsFiltres,
    String? specialiteActive,
    bool clearSpecialite = false,
    String? searchQuery,
    DoctorsModel? medecinSelectionne,
    List<DoctorAvailabilitiesModel>? availibilities,
    bool? availibilitiesLoading,
    bool clearDate = false,
    DoctorAvailabilitiesModel? disponibiliteSelectionnee,
    bool clearDispo = false,
    String? rdvType,
  }) {
    return MedecinLoaded(
      tousLesdoctors: tousLesdoctors,
      medecinsFiltres: medecinsFiltres ?? this.medecinsFiltres,
      specialityActive: clearSpecialite
          ? null
          : specialiteActive ?? this.specialityActive,
      searchQuery: searchQuery ?? this.searchQuery,
      medecinSelectionne: medecinSelectionne ?? this.medecinSelectionne,
      availibilities: availibilities ?? this.availibilities,
      availibilitiesLoading:
          availibilitiesLoading ?? this.availibilitiesLoading,
      disponibiliteSelectionnee: clearDispo
          ? null
          : disponibiliteSelectionnee ?? this.disponibiliteSelectionnee,
      rdvType: rdvType ?? this.rdvType,
    );
  }

  @override
  List<Object?> get props => [
    tousLesdoctors,
    medecinsFiltres,
    specialityActive,
    searchQuery,
    medecinSelectionne,
    availibilities,
    availibilitiesLoading,
    disponibiliteSelectionnee,
    rdvType,
  ];
}
