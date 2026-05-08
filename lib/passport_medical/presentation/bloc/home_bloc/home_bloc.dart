import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/data/datasources/home_datasource.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_allergies.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_prescriptions.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vaccinations.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vitals.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/rdv_detail_model.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/appointments.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_state.dart';

import '../../../data/models/others/length_table.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeDatasource _datasource;
  HomeBloc(this._datasource) : super(HomeInitial()) {
    on<HomeDataLoaded>(_onCharger);
    on<HomePinVisibiliyChange>(_onTogglePin);
    on<HomePinCopy>(_onCopyPin);
    on<DossierSpecialiteSelectionne>(_onSelectSpecialite);
    on<DossierSpecialiteFermer>(_onFermerSpecialite);
    on<HomeRafraichi>(_onRafraichir);
  }
  Future<void> _onCharger(HomeDataLoaded event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const HomeErreur(message: 'Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      log(
        'Patient: ${patientConnected.firstName} ${patientConnected.lastName} — id: $patientId',
      );
      log("Home Bloc: Les données en cours de chargement");
      final resultats = await Future.wait([
        _datasource.getAppointmentByPatientId(patientId),
        _datasource.getPatientCounts(patientId),
        _datasource.getPatientProfile(patientId),
        _datasource.getPatientAllergies(patientId),
        _datasource.getPatientPrescriptions(patientId),
        _datasource.getPatientVitals(patientId),
        _datasource.getPatientVaccinations(patientId),
        _datasource.getRdvAvecMedecin(patientId),
      ]);
      final e = resultats.map((element) => log(element.toString()));
      log("Data: $resultats");
      log("data: $e");
      final appoitements = resultats[0] as List<AppointmentsModel>;
      final counts = resultats[1] as LengthTableModel;
      final patient = resultats[2] as PatientModel;
      final allergie = resultats[3] as List<PatientAllergiesModel>;
      final prescriptions = resultats[4] as List<PatientPrescriptionsModel>;
      final patientInfo = resultats[2] as PatientModel;
      final patientAllergie = resultats[3] as List<PatientAllergiesModel>;
      final vitals = resultats[5] as List<PatientVitalsModel>;
      final vaccinations = resultats[6] as List<PatientVaccinationsModel>;
      final rdvs = resultats[7] as List<RdvDetailModel>;

      final stats = _datasource.calculStatSpecialite(rdvs);

      log(
        'Dossier chargé — vitals: ${vitals.length} '
        '| vaccins: ${vaccinations.length} '
        '| RDV: ${rdvs.length} '
        '| spécialités: ${stats.length}',
      );

      emit(
        HomeLoaded(
          pin: patient.pin ?? '2323',
          piVisible: false,
          pinCopy: false,
          mesRendezVous: appoitements,
          nbOrdonnances: counts.prescriptionCount,
          nbVaccins: counts.vaccinationCount,
          nbConsultations: counts.appointementCount,
          nbAllergies: counts.allergiesCount,
          allergies: allergie,
          prescriptions: prescriptions,
          groupeSanguin: patient.bloodType,
          medecinTraitant: patient.treatingDoctorId,
          patientModel: patientInfo,
          patientAllergiesModel: patientAllergie,
          statsSpecialits: stats,
          vitals: vitals,
          vaccinations: vaccinations,
          tousLesRdv: rdvs,
          //contactUrgence: '',
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(HomeErreur(message: 'Impossible de charger les informations'));
    }
  }

  void _onTogglePin(HomePinVisibiliyChange event, Emitter<HomeState> emit) {
    final s = state;

    if (s is! HomeLoaded) return;

    emit(s.copyWith(piVisible: !s.piVisible));
  }

  Future<void> _onCopyPin(HomePinCopy event, Emitter<HomeState> emit) async {
    final s = state;
    if (s is! HomeLoaded) return;

    await Clipboard.setData(ClipboardData(text: s.pin));
    emit(s.copyWith(pinCopy: true));
    await Future.delayed(Duration(seconds: 2));
    emit(s.copyWith(pinCopy: false));
  }

  void _onSelectSpecialite(
    DossierSpecialiteSelectionne event,
    Emitter<HomeState> emit,
  ) {
    final s = state;
    if (s is! HomeLoaded) return;
    emit(s.copyWith(specialiteSelectionnee: event.specialite));
  }

  void _onFermerSpecialite(
    DossierSpecialiteFermer event,
    Emitter<HomeState> emit,
  ) {
    final s = state;
    if (s is! HomeLoaded) return;
    emit(s.copyWith(clearSpecialite: true));
  }

  Future<void> _onRafraichir(
    HomeRafraichi event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final patientData = await _datasource.getPatientConnecte();
      if (patientData == null) return;
      final patientId = patientData.patientId;

      final resultats = await Future.wait([
        _datasource.getAppointmentByPatientId(patientId),
        _datasource.getPatientCounts(patientId),
        _datasource.getPatientProfile(patientId),
        _datasource.getPatientAllergies(patientId),
        _datasource.getPatientPrescriptions(patientId),
        _datasource.getPatientVitals(patientId),
        _datasource.getPatientVaccinations(patientId),
        _datasource.getRdvAvecMedecin(patientId),
      ]);
      final e = resultats.map((element) => log(element.toString()));
      log("Data: $resultats");
      log("data: $e");
      final appoitements = resultats[0] as List<AppointmentsModel>;
      final counts = resultats[1] as LengthTableModel;
      final patient = resultats[2] as PatientModel;
      final allergie = resultats[3] as List<PatientAllergiesModel>;
      final prescriptions = resultats[4] as List<PatientPrescriptionsModel>;
      final patientInfo = resultats[2] as PatientModel;
      final patientAllergie = resultats[3] as List<PatientAllergiesModel>;
      final vitals = resultats[5] as List<PatientVitalsModel>;
      final vaccinations = resultats[6] as List<PatientVaccinationsModel>;
      final rdvs = resultats[7] as List<RdvDetailModel>;

      final stats = _datasource.calculStatSpecialite(rdvs);

      log(
        'Dossier chargé — vitals: ${vitals.length} '
        '| vaccins: ${vaccinations.length} '
        '| RDV: ${rdvs.length} '
        '| spécialités: ${stats.length}',
      );

      emit(
        HomeLoaded(
          pin: patient.pin ?? '2323',
          piVisible: false,
          pinCopy: false,
          mesRendezVous: appoitements,
          nbOrdonnances: counts.prescriptionCount,
          nbVaccins: counts.vaccinationCount,
          nbConsultations: counts.appointementCount,
          nbAllergies: counts.allergiesCount,
          allergies: allergie,
          prescriptions: prescriptions,
          groupeSanguin: patient.bloodType,
          medecinTraitant: patient.treatingDoctorId,
          patientModel: patientInfo,
          patientAllergiesModel: patientAllergie,
          statsSpecialits: stats,
          vitals: vitals,
          vaccinations: vaccinations,
          tousLesRdv: rdvs,
          //contactUrgence: '',
        ),
      );
    } catch (e) {
      log('Rafraîchissement erreur: $e');
      // Ne pas émettre d'erreur — garder les données existantes
    }
  }
}
