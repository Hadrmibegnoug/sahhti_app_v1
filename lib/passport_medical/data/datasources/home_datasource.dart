import 'dart:developer';

import 'package:sahha_pass/passport_medical/data/models/data_medical/patient.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_allergies.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_prescriptions.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vaccinations.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vitals.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/rdv_detail_model.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/specialit_stat_model.dart';
import 'package:sahha_pass/passport_medical/data/models/others/length_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/medecin_rdv/appointments.dart';

class HomeDatasource {
  final SupabaseClient _client;
  HomeDatasource(this._client);

  Future<LengthTableModel> getPatientCounts(int patientId) async {
    final allergies = await _client
        .from('patient_allergies')
        .select()
        .eq('patient_id', patientId);

    final prescriptions = await _client
        .from('patient_prescriptions')
        .select()
        .eq('patient_id', patientId);

    final vaccins = await _client
        .from('patient_vaccinations')
        .select()
        .eq('patient_id', patientId);

    final appointementCount = await _client
        .from('appointments')
        .select()
        .eq('patient_id', patientId);

    return LengthTableModel(
      allergiesCount: allergies.length,
      prescriptionCount: prescriptions.length,
      vaccinationCount: vaccins.length,
      appointementCount: appointementCount.length,
    );
  }

  Future<List<RdvDetailModel>> getAppointmentByPatientId(
    int patientId,
  ) async {
    final data = await _client
        .from('appointments')
        .select('*, doctors(first_name, last_name, specialty)')
        .eq('patient_id', patientId);
    log('Résultat des rendez-vous pour le patient $patientId: $data');
    return (data as List)
        .map((e) => RdvDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // home_datasource.dart — ajouter la récupération du profil patient

  Future<PatientModel?> getPatientProfile(int patientId) async {
    final data = await _client
        .from('patients')
        .select()
        .eq('patient_id', patientId)
        .maybeSingle();
    log("*************************************************************");
    log('Patient trouvé: $data');
    log("*************************************************************");
    if (data == null) return null;
    return PatientModel.fromJson(data);
  }

  Future<List<PatientAllergiesModel>> getPatientAllergies(int patientId) async {
    final data = await _client
        .from('patient_allergies')
        .select()
        .eq('patient_id', patientId);
    log('Allergies du patient : $data');
    return (data as List)
        .map((e) => PatientAllergiesModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PatientPrescriptionsModel>> getPatientPrescriptions(
    int patientId,
  ) async {
    final data = await _client
        .from('patient_prescriptions')
        .select()
        .eq('patient_id', patientId);
    log('Ordonnances du patient : $data');
    return (data as List)
        .map(
          (e) => PatientPrescriptionsModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<PatientVitalsModel>> getPatientVitals(int patientId) async {
    final data = await _client
        .from('patient_vitals')
        .select()
        .eq('patient_id', patientId);
    log('Vital du patient : $data');
    return (data as List).map((e) {
      try {
        return PatientVitalsModel.fromJson(e);
      } catch (err) {
        log(
          'Erreur parsing vital: $err\nDonnée: $e',
        ); // ← montre exactement quel champ
        rethrow;
      }
    }).toList();
  }

  Future<List<PatientVaccinationsModel>> getPatientVaccinations(
    int patientId,
  ) async {
    final data = await _client
        .from('patient_vaccinations')
        .select()
        .eq('patient_id', patientId);
    log('Vaccins du patient : $data');
    return (data as List).map((elem) {
      try {
        return PatientVaccinationsModel.fromJson(elem);
      } catch (err) {
        log('Erreur parsing vaccination: $err\nDonnée: $elem');
        rethrow;
      }
    }).toList();
  }

  Future<List<RdvDetailModel>> getRdvAvecMedecin(int patientId) async {
    final data = await _client
        .from('appointments')
        .select('*, doctors(first_name, last_name, specialty)')
        .eq('patient_id', patientId);
    //.order('appointment_date', ascending: false);
    log("Rdv: $data");
    return (data as List).map((e) {
      try {
        return RdvDetailModel.fromJson(e);
      } catch (err) {
        log(
          'Erreur parsing rdv: $err\nDonnée: $e',
        ); // ← montre exactement quel champ
        rethrow;
      }
    }).toList();
  }

  List<SpecialitStatModel> calculStatSpecialite(List<RdvDetailModel> rdvs) {
    final Map<String, int> comptage = {};

    for (final rdv in rdvs) {
      final spec = rdv.medecinSpecialite.isEmpty
          ? 'Général'
          : rdv.medecinSpecialite;
      comptage[spec] = (comptage[spec] ?? 0) + 1;
    }
    final liste =
        comptage.entries
            .map(
              (entry) =>
                  SpecialitStatModel(specialite: entry.key, nbRdv: entry.value),
            )
            .toList()
          ..sort((a, b) => b.nbRdv.compareTo(a.nbRdv));
    return liste;
  }

  Future<PatientModel?> getPatientConnecte() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté.');

    final data = await _client
        .from('patients')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    log('Patient connecté (userId: $userId): $data');
    if (data == null) return null;
    return PatientModel.fromJson(data);
  }
}
