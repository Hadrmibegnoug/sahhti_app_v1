import 'dart:developer';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/appointments.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctor_availabilities.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/data_medical/patient.dart';

class MedecinDatasource {
  final SupabaseClient _client;
  MedecinDatasource(this._client);

  // Tous les médecins
  Future<List<DoctorsModel>> getAllDoctor() async {
    final data = await _client
        .from('doctors')
        .select()
        .order('rating', ascending: false);
    log('Médecins: ${data.length}');
    return (data as List)
        .map((e) => DoctorsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Disponibilités d'un médecin
  Future<List<DoctorAvailabilitiesModel>> getDoctorsAvailibilities(
    int doctorId,
  ) async {
    log('🔍 Disponibilités pour doctorId: $doctorId');
    final data = await _client
        .from('doctor_availability')
        .select()
        .eq('doctor_id', doctorId);
    log('✅ ${data.length} disponibilité(s)');
    return (data as List)
        .map(
          (e) => DoctorAvailabilitiesModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  // ← CORRIGÉ : bookAppointment avec start_time, end_time et date format
  Future<AppointmentsModel> bookAppointment({
    required int patientId,
    required int doctorId,
    required DoctorAvailabilitiesModel disponibilite,
    required String type,
    required String reason,
  }) async {
    // Trouver la prochaine date correspondant au jour de la semaine
    final date = _prochaineDate(disponibilite.dayOfWeek);

    // Format date : 'YYYY-MM-DD' pour Supabase (type date)
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    log(
      '📅 Réservation: $dateStr '
      '${disponibilite.startTime} → ${disponibilite.endTime} '
      'type: $type',
    );

    final data = await _client
        .from('appointments')
        .insert({
          'patient_id': patientId,
          'doctor_id': doctorId,
          'appointment_date': dateStr, // ← date format
          'start_time': disponibilite.startTime, // ← start_time
          'end_time': disponibilite.endTime, // ← end_time
          'status': 'pending',
          'type': type,
          'reason': reason,
          'booked_by_patient': true,
        })
        .select()
        .single();

    log('✅ RDV créé: $data');
    return AppointmentsModel.fromJson(data);
  }

  // ── Utilitaire : prochaine date du jour de la semaine ────────────
  DateTime _prochaineDate(String dayOfWeek) {
    const jours = {
      'lundi': 1,
      'monday': 1,
      'mardi': 2,
      'tuesday': 2,
      'mercredi': 3,
      'wednesday': 3,
      'jeudi': 4,
      'thursday': 4,
      'vendredi': 5,
      'friday': 5,
      'samedi': 6,
      'saturday': 6,
      'dimanche': 7,
      'sunday': 7,
    };

    final jourCible = jours[dayOfWeek.toLowerCase()] ?? 1;
    final maintenant = DateTime.now();
    var diff = jourCible - maintenant.weekday;
    if (diff <= 0) diff += 7; // toujours la prochaine occurrence
    return maintenant.add(Duration(days: diff));
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
