import 'package:equatable/equatable.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctor_availabilities.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctors.dart';

abstract class MedecinEvent extends Equatable {
  const MedecinEvent();
  @override
  List<Object?> get props => [];
}

class MedecinPageOuverte extends MedecinEvent {
  const MedecinPageOuverte();
}

class SpecialitySelected extends MedecinEvent {
  final String? specialite;
  const SpecialitySelected(this.specialite);
  @override
  List<Object?> get props => [specialite];
}

class MedecinSearchChanged extends MedecinEvent {
  final String query;
  const MedecinSearchChanged(this.query);
  @override
  List<Object> get props => [query];
}

class MedecinDetailOuvert extends MedecinEvent {
  final DoctorsModel doctor;
  const MedecinDetailOuvert(this.doctor);
  @override
  List<Object> get props => [doctor];
}

// ← NOUVEAU : patient clique sur une disponibilité
class DisponibiliteSelectionnee extends MedecinEvent {
  final DoctorAvailabilitiesModel disponibilite;
  const DisponibiliteSelectionnee(this.disponibilite);
  @override
  List<Object> get props => [disponibilite];
}

class RdvTypeSelectionne extends MedecinEvent {
  final String type; // 'in_person' | 'teleconsult'
  const RdvTypeSelectionne(this.type);
  @override
  List<Object> get props => [type];
}

class RdvConfirm extends MedecinEvent {
  final int doctorId;
  final String type;
  final String reason;
  // ← date/heure viennent de la disponibilité sélectionnée
  const RdvConfirm({
    required this.doctorId,
    required this.type,
    required this.reason,
  });
  @override
  List<Object> get props => [doctorId, type, reason];
}

class MedecinsRefraichies extends MedecinEvent {
  const MedecinsRefraichies();
  @override
  List<Object> get props => [];
}
