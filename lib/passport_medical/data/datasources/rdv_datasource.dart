import 'dart:developer';

import 'package:sahha_pass/passport_medical/data/models/data_medical/rdv_detail_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/data_medical/patient.dart';

class RdvDatasource {
  final SupabaseClient _client;
  RdvDatasource(this._client);

  Future<List<RdvDetailModel>> getAppointments(int patientId) async {
    final response = await _client
        .from('appointments')
        .select('*, doctors(first_name, last_name, specialty)')
        .eq('patient_id', patientId);
    log("rdv Patient: $response");
    return response.map((e) => RdvDetailModel.fromJson(e)).toList();
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
