import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/auth_datasource.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDatasource _datasource;

  AuthBloc(this._datasource) : super(AuthInitial()) {
    on<NniSaisi>(_onNni);
    on<InscriptionDemandee>(_onInscription);
    on<OtpInscriptionVerifie>(_onVerifierOtp);
    on<OtpRenvoye>(_onRenvoyerOtp);
    on<ConnexionDemandee>(_onConnecter);
    on<DeconnexionDemandee>(_onDeconnecter);
    // PIN
    on<PinInscriptionInitialise>(_onPinInscriptionInit);
    on<PinConnexionInitialise>(_onPinConnexionInit);
    on<PinChiffreAjoute>(_onPinAjouter);
    on<PinChiffreSupprime>(_onPinSupprimer);
  }

  // ── NNI ──────────────────────────────────────────────────────
  Future<void> _onNni(NniSaisi e, Emitter<AuthState> emit) async {
    emit(AuthChargement());
    try {
      final patient = await _datasource.verifierNni(e.nni);
      if (patient == null) {
        emit(const AuthErreur('NNI introuvable.'));
      } else {
        emit(NniTrouve(patient));
      }
    } catch (err) {
      emit(const AuthErreur('Erreur de connexion. Réessayez.'));
    }
  }

  // ── Inscription ───────────────────────────────────────────────
  Future<void> _onInscription(
    InscriptionDemandee e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthChargement());
    try {
      await _datasource.demanderInscription(telephone: e.telephone, pin: e.pin);
      emit(OtpEnvoye(telephone: e.telephone, pin: e.pin, patient: e.patient));
    } catch (err) {
      log('Inscription: $err');
      emit(AuthErreur(_parseErreur(err.toString())));
    }
  }

  // ── Vérifier OTP ──────────────────────────────────────────────
  Future<void> _onVerifierOtp(
    OtpInscriptionVerifie e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthChargement());
    try {
      final userId = await _datasource.verifierOtpInscription(
        telephone: e.telephone,
        otpCode: e.otpCode,
      );
      await _datasource.creerProfilPatient(
        userId: userId,
        patient: e.patient,
        telephone: e.telephone,
        pin: e.pin,
      );
      emit(AuthConnecte());
    } catch (err) {
      emit(const AuthErreur('Code incorrect ou expiré.'));
    }
  }

  // ── Renvoyer OTP ──────────────────────────────────────────────
  Future<void> _onRenvoyerOtp(OtpRenvoye e, Emitter<AuthState> emit) async {
    emit(OtpRenvoyeChargement());
    try {
      await _datasource.renvoyerOtp(e.telephone);
    } catch (err) {
      log('Renvoi OTP: $err');
    }
  }

  // ── Connexion ─────────────────────────────────────────────────
  Future<void> _onConnecter(
    ConnexionDemandee e,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthChargement());
    try {
      await _datasource.connecter(telephone: e.telephone, pin: e.pin);
      emit(AuthConnecte());
    } catch (err) {
      emit(const AuthErreur('Numéro ou code PIN incorrect.'));
    }
  }

  // ── Déconnexion ───────────────────────────────────────────────
  Future<void> _onDeconnecter(
    DeconnexionDemandee e,
    Emitter<AuthState> emit,
  ) async {
    await _datasource.deconnecter();
    emit(AuthInitial());
  }

  // ── PIN Inscription — initialiser ─────────────────────────────
  void _onPinInscriptionInit(
    PinInscriptionInitialise e,
    Emitter<AuthState> emit,
  ) {
    emit(const PinSaisieState());
  }

  // ── PIN Connexion — initialiser ───────────────────────────────
  void _onPinConnexionInit(PinConnexionInitialise e, Emitter<AuthState> emit) {
    emit(const PinConnexionState());
  }

  // ── Ajouter un chiffre ────────────────────────────────────────
  void _onPinAjouter(PinChiffreAjoute e, Emitter<AuthState> emit) {
    final s = state;

    // ── Cas inscription ──────────────────────────────────────
    if (s is PinSaisieState) {
      if (s.current.length >= 4) return;

      final nouveauPin = !s.etapeConfirmation ? [...s.pin, e.chiffre] : s.pin;
      final nouveauConfirm = s.etapeConfirmation
          ? [...s.pinConfirmation, e.chiffre]
          : s.pinConfirmation;

      final nouvelEtat = s.copyWith(
        pin: nouveauPin,
        pinConfirmation: nouveauConfirm,
      );

      // PIN 1 complet → passer à la confirmation
      if (!s.etapeConfirmation && nouveauPin.length == 4) {
        emit(nouvelEtat.copyWith(etapeConfirmation: true));
        return;
      }

      // PIN 2 complet → valider
      if (s.etapeConfirmation && nouveauConfirm.length == 4) {
        emit(nouvelEtat);
        // La page déclenche InscriptionDemandee si les PIN correspondent
        return;
      }

      emit(nouvelEtat);
      return;
    }

    // ── Cas connexion ────────────────────────────────────────
    if (s is PinConnexionState) {
      if (s.pin.length >= 4) return;
      final nouveau = [...s.pin, e.chiffre];
      emit(PinConnexionState(pin: nouveau));
    }
  }

  // ── Supprimer un chiffre ──────────────────────────────────────
  void _onPinSupprimer(PinChiffreSupprime e, Emitter<AuthState> emit) {
    final s = state;

    if (s is PinSaisieState) {
      if (s.etapeConfirmation) {
        if (s.pinConfirmation.isEmpty) return;
        emit(
          s.copyWith(
            pinConfirmation: s.pinConfirmation.sublist(
              0,
              s.pinConfirmation.length - 1,
            ),
          ),
        );
      } else {
        if (s.pin.isEmpty) return;
        emit(s.copyWith(pin: s.pin.sublist(0, s.pin.length - 1)));
      }
    }

    if (s is PinConnexionState) {
      if (s.pin.isEmpty) return;
      emit(PinConnexionState(pin: s.pin.sublist(0, s.pin.length - 1)));
    }
  }

  String _parseErreur(String e) {
    if (e.contains('already registered')) return 'Numéro déjà utilisé.';
    if (e.contains('network')) return 'Vérifiez votre connexion.';
    return 'Une erreur est survenue.';
  }
}
