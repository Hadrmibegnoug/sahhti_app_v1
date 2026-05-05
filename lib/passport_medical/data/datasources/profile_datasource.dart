// profile/data/datasource/profile_datasource.dart

import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/data_medical/patient.dart';
import '../models/profile/profile_model.dart';

class ProfileDatasource {
  final SupabaseClient _client;
  ProfileDatasource(this._client);

  // ── Récupérer le profil du patient connecté ───────────────────
  Future<ProfileModel?> getProfile(int patientID) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté.');

    final data = await _client
        .from('patients')
        .select()
        .eq('patient_id', patientID)
        .maybeSingle();

    log('Profile chargé: $data');
    if (data == null) return null;
    try {
      return ProfileModel.fromJson(data);
    } catch (e) {
      log(
        'Erreur parsing rdv: $e\nDonnée: $data',
      ); // ← montre exactement quel champ
      rethrow;
    }
  }

  // ── Mettre à jour les infos personnelles ─────────────────────
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? gender,
    String? dateOfBirth,
    String? bloodType,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté.');

    final updates = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
    };
    if (phone != null) updates['phone'] = phone;
    if (gender != null) updates['gender'] = gender;
    if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth;
    if (bloodType != null) updates['blood_type'] = bloodType;

    final data = await _client
        .from('patients')
        .update(updates)
        .eq('user_id', userId)
        .select()
        .single();

    log('Profile mis à jour: $data');
    return ProfileModel.fromJson(data);
  }

  // ── Changer le PIN ─────────────────────────────────────────────
  Future<void> changerPin({
    required String ancienPin,
    required String nouveauPin,
  }) async {
    final phone = _client.auth.currentUser?.phone;
    if (phone == null) throw Exception('Téléphone introuvable.');

    // Vérifier l'ancien PIN en se reconnectant
    await _client.auth.signInWithPassword(
      phone: phone,
      password: '${ancienPin}sahhti',
    );

    // Changer le mot de passe
    await _client.auth.updateUser(
      UserAttributes(password: '${nouveauPin}sahhti'),
    );
    log('PIN changé avec succès');
  }

  // ── Déconnexion ← déplacé depuis AuthDatasource ───────────────
  Future<void> deconnecter() async {
    await _client.auth.signOut();
    log('Utilisateur déconnecté');
  }

  // ── Vérifier si connecté ──────────────────────────────────────
  bool get estConnecte => _client.auth.currentSession != null;

  String? get currentUserId => _client.auth.currentUser?.id;
  String? get currentPhone => _client.auth.currentUser?.phone;

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
