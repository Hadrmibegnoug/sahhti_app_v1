import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/profile_datasource.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileDatasource _datasource;

  ProfileBloc(this._datasource) : super(ProfileInitial()) {
    on<ProfileCharge>(_onCharger);
    on<ProfileDeconnexionDemandee>(_onDeconnecter);
    on<ProfileMisAJour>(_onMettreAJour);
    on<ProfilePinChange>(_onChangerPin);
  }

  // ── Charger le profil ─────────────────────────────────────────
  Future<void> _onCharger(
    ProfileCharge event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileChargement());
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const ProfileErreur('Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      final profile = await _datasource.getProfile(patientId);
      if (profile == null) {
        emit(const ProfileErreur('Profil introuvable.'));
      } else {
        emit(ProfileLoaded(profile));
      }
    } catch (e) {
      log('ProfileBloc chargement erreur: $e');
      emit(ProfileErreur(e.toString()));
    }
  }

  // ── Déconnexion ───────────────────────────────────────────────
  Future<void> _onDeconnecter(
    ProfileDeconnexionDemandee event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileChargement());
    try {
      await _datasource.deconnecter(); // ← depuis ProfileDatasource
      emit(ProfileDeconnecte());
    } catch (e) {
      log('Déconnexion erreur: $e');
      emit(ProfileErreur('Erreur lors de la déconnexion.'));
    }
  }

  // ── Mettre à jour le profil ───────────────────────────────────
  Future<void> _onMettreAJour(
    ProfileMisAJour event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileChargement());
    try {
      final updated = await _datasource.updateProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        gender: event.gender,
        dateOfBirth: event.dateOfBirth,
        bloodType: event.bloodType,
      );
      emit(ProfileMisAJourSucces(updated));
    } catch (e) {
      log('ProfileBloc mise à jour erreur: $e');
      emit(ProfileErreur('Impossible de mettre à jour le profil.'));
    }
  }

  // ── Changer le PIN ────────────────────────────────────────────
  Future<void> _onChangerPin(
    ProfilePinChange event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfilePinEnCours());
    try {
      await _datasource.changerPin(
        ancienPin: event.ancienPin,
        nouveauPin: event.nouveauPin,
      );
      emit(ProfilePinSucces());
    } catch (e) {
      log('Changement PIN erreur: $e');
      emit(const ProfileErreur('Ancien PIN incorrect. Réessayez.'));
    }
  }
}
