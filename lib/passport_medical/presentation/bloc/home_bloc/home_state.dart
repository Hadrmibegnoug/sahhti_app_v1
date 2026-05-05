import 'package:equatable/equatable.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_allergies.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_prescriptions.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vaccinations.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vitals.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/rdv_detail_model.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/specialit_stat_model.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/appointments.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class PassportLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String pin;
  final bool piVisible;
  final bool pinCopy;
  final List<AppointmentsModel> mesRendezVous;
  final int nbOrdonnances;
  final int nbVaccins;
  final int nbConsultations;
  final int nbAllergies;
  final List<PatientAllergiesModel> allergies;
  final List<PatientPrescriptionsModel> prescriptions;
  final String groupeSanguin;
  final String medecinTraitant;
  final String? contactUrgence;
  final PatientModel patientModel;
  final List<PatientAllergiesModel> patientAllergiesModel;
  final List<SpecialitStatModel> statsSpecialits;
  final List<PatientVitalsModel> vitals;
  final List<PatientVaccinationsModel> vaccinations;
  final List<RdvDetailModel> tousLesRdv;
  final String? specialiteSelectionne;

  const HomeLoaded({
    required this.pin,
    required this.piVisible,
    required this.pinCopy,
    required this.mesRendezVous,
    required this.nbOrdonnances,
    required this.nbVaccins,
    required this.nbConsultations,
    required this.nbAllergies,
    required this.allergies,
    required this.prescriptions,
    required this.groupeSanguin,
    required this.medecinTraitant,
    this.contactUrgence,
    required this.patientModel,
    required this.patientAllergiesModel,
    required this.statsSpecialits,
    required this.vitals,
    required this.vaccinations,
    required this.tousLesRdv,
    this.specialiteSelectionne,
  });

  List<RdvDetailModel> get rdvFiltres {
    if (specialiteSelectionne == null) return tousLesRdv;
    return tousLesRdv
        .where((r) => r.medecinSpecialite == specialiteSelectionne)
        .toList();
  }

  // double? get dernierPoids {
  //   final poids = vitals.where((v) => v.vitalType == 'weight').toList();
  //   if (poids.isEmpty) return null;
  //   return poids.last.value;
  // }

  Map<String, List<PatientVitalsModel>> get vitalsByType {
    final Map<String, List<PatientVitalsModel>> map = {};
    for (final v in vitals) {
      map.putIfAbsent(v.vitalType, () => []).add(v);
    }
    return map;
  }

  // Dernière valeur pour un type donn

  // Valeurs pour la courbe d'un type
  List<num> valeursForChart(String type) {
    return vitalsByType[type]?.map((v) => v.value).toList() ?? [];
  }

  // Liste des types disponibles dans les données
  List<String> get typesDisponibles => vitalsByType.keys.toList();

  HomeLoaded copyWith({
    bool? piVisible,
    bool? pinCopy,
    String? prochainRdv,
    List<AppointmentsModel>? mesRendezVous,
    int? nbOrdonnances,
    int? nbVaccins,
    int? nbConsultations,
    int? nbAllergies,
    List<PatientAllergiesModel>? allergies,
    List<PatientPrescriptionsModel>? prescriptions,
    String? groupeSanguin,
    String? medecinTraitant,
    String? contactUrgence,
    PatientModel? patientModel,
    List<PatientAllergiesModel>? patientAllergiesModel,
    String? specialiteSelectionnee,
    bool clearSpecialite = false,
  }) {
    return HomeLoaded(
      pin: pin,
      piVisible: piVisible ?? this.piVisible,
      pinCopy: pinCopy ?? this.pinCopy,
      mesRendezVous: mesRendezVous ?? this.mesRendezVous,
      nbOrdonnances: nbOrdonnances ?? this.nbOrdonnances,
      nbVaccins: nbVaccins ?? this.nbVaccins,
      nbConsultations: nbConsultations ?? this.nbConsultations,
      nbAllergies: nbAllergies ?? this.nbAllergies,
      allergies: allergies ?? this.allergies,
      prescriptions: prescriptions ?? this.prescriptions,
      groupeSanguin: groupeSanguin ?? this.groupeSanguin,
      medecinTraitant: medecinTraitant ?? this.medecinTraitant,
      contactUrgence: contactUrgence ?? this.contactUrgence,
      patientModel: patientModel ?? this.patientModel,
      patientAllergiesModel:
          patientAllergiesModel ?? this.patientAllergiesModel,
      statsSpecialits: statsSpecialits,
      vitals: vitals,
      vaccinations: vaccinations,
      tousLesRdv: tousLesRdv,
      specialiteSelectionne: clearSpecialite
          ? null
          : specialiteSelectionnee ?? specialiteSelectionne,
    );
  }

  @override
  List<Object?> get props => [
    pin,
    piVisible,
    pinCopy,
    mesRendezVous,
    nbOrdonnances,
    nbVaccins,
    nbConsultations,
    nbAllergies,
    allergies,
    groupeSanguin,
    medecinTraitant,
    contactUrgence,
    statsSpecialits,
    vitals,
    vaccinations,
    specialiteSelectionne,
  ];
}

class HomeErreur extends HomeState {
  final String message;
  const HomeErreur({required this.message});
  @override
  List<Object?> get props => [message];
}
