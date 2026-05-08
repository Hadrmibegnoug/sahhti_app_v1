// auth/data/datasource/auth_datasource.dart

import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/registry_patient_model.dart';

class AuthDatasource {
  final SupabaseClient _client;
  AuthDatasource(this._client);

  // ── 1. Vérifier NNI ──────────────────────────────────────────
  Future<RegistryPatientModel?> verifierNni(String nni) async {
    final data = await _client
        .from('patient_registry')
        .select()
        .eq('nni', nni.trim())
        .maybeSingle();

    log('Registre NNI $nni: $data');
    if (data == null) return null;
    return RegistryPatientModel.fromJson(data);
  }

  // ── 2. Inscription — envoie SMS OTP via Twilio ────────────────
  // signUp avec phone + password → Twilio envoie un SMS à 6 chiffres
  Future<void> demanderInscription({
    required String telephone,
    required String pin,
  }) async {
    final phone = _formaterTelephone(telephone);
    final password = _pinEnPassword(pin);

    log('Inscription demandée pour $phone');

    await _client.auth.signUp(phone: phone, password: password);
    // Supabase envoie automatiquement le SMS via Twilio
  }

  // ── 3. Vérifier le code SMS (inscription) ─────────────────────
  Future<String> verifierOtpInscription({
    required String telephone,
    required String otpCode,
  }) async {
    final phone = _formaterTelephone(telephone);

    final response = await _client.auth.verifyOTP(
      phone: phone,
      token: otpCode,
      type: OtpType.sms,
    );

    if (response.user == null) {
      throw Exception('Code incorrect ou expiré.');
    }

    log('OTP vérifié, userId: ${response.user!.id}');
    return response.user!.id;
  }

  // ── 4. Créer le profil patient après vérification OTP ─────────
  Future<void> creerProfilPatient({
    required String userId,
    required RegistryPatientModel patient,
    required String telephone,
    required String pin,
  }) async {
    final qrToken = const Uuid().v4();
    log('Création profil — userId: $userId, qrToken: $qrToken');
    await _client.from('patients').insert({
      'user_id': userId,
      'nni': patient.nni,
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'phone': _formaterTelephone(telephone),
      'gender': patient.gender,
      'date_of_birth': patient.dateOfBirth,
      'blood_type': 'Inconnu',
      'pin': pin, // ← PIN choisi à l'inscription
      'qr_token': qrToken,
    });

    log('Profil patient créé pour userId: $userId');
  }

  // ── 5. Connexion — téléphone + PIN ────────────────────────────
  Future<void> connecter({
    required String telephone,
    required String pin,
  }) async {
    final phone = _formaterTelephone(telephone);
    final password = _pinEnPassword(pin);

    await _client.auth.signInWithPassword(phone: phone, password: password);

    log('Connecté: ${_client.auth.currentUser?.id}');
    log('Token JWT: ${_client.auth.currentSession?.accessToken}');
  }

  // ── 6. Renvoyer le SMS ────────────────────────────────────────
  Future<void> renvoyerOtp(String telephone) async {
    final phone = _formaterTelephone(telephone);
    await _client.auth.resend(type: OtpType.sms, phone: phone);
    log('SMS renvoyé à $phone');
  }

  // ── 7. Déconnexion ────────────────────────────────────────────
  Future<void> deconnecter() async {
    await _client.auth.signOut();
    log('Déconnecté');
  }

  // ── Utilitaires ───────────────────────────────────────────────
  String _formaterTelephone(String phone) {
    final clean = phone.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('222')) return '+$clean';
    return '+222$clean';
  }

  // PIN 4 chiffres + suffixe pour respecter min 6 chars Supabase
  String _pinEnPassword(String pin) => '${pin}sahhti';

  bool get estConnecte => _client.auth.currentSession != null;
  String? get currentUserId => _client.auth.currentUser?.id;
}
