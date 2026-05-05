// medecin_bloc/medecin_bloc.dart

import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/data/datasources/medecin_datasource.dart';
import 'medecin_event.dart';
import 'medecin_state.dart';

class MedecinBloc extends Bloc<MedecinEvent, MedecinState> {
  final MedecinDatasource _datasource;

  MedecinBloc(this._datasource) : super(MedecinInitial()) {
    on<MedecinPageOuverte>(_onPageOuverte);
    on<SpecialitySelected>(_onSpecialitySelected);
    on<MedecinSearchChanged>(_onSearch);
    on<MedecinDetailOuvert>(_onDetailOuvert);
    on<DisponibiliteSelectionnee>(_onDisponibiliteSelectionnee); // ← nouveau
    on<RdvTypeSelectionne>(_onTypeSelectionne);
    on<RdvConfirm>(_onRdvConfirme);
  }

  // ── Chargement liste médecins ─────────────────────────────────
  Future<void> _onPageOuverte(
    MedecinPageOuverte event,
    Emitter<MedecinState> emit,
  ) async {
    emit(MedecinLoading());
    try {
      final doctors = await _datasource.getAllDoctor();
      emit(MedecinLoaded(tousLesdoctors: doctors, medecinsFiltres: doctors));
    } catch (e) {
      log('MedecinBloc erreur: $e');
      emit(const MedecinError(message: 'Impossible de charger les médecins.'));
    }
  }

  // ── Filtre spécialité ─────────────────────────────────────────
  void _onSpecialitySelected(
    SpecialitySelected event,
    Emitter<MedecinState> emit,
  ) {
    final s = state;
    if (s is! MedecinLoaded) return;
    final filtres = event.specialite == null
        ? s.tousLesdoctors
        : s.tousLesdoctors
              .where((d) => d.specialty == event.specialite)
              .toList();
    emit(
      s.copyWith(
        medecinsFiltres: filtres,
        specialiteActive: event.specialite,
        clearSpecialite: event.specialite == null,
      ),
    );
  }

  // ── Recherche ────────────────────────────────────────────────
  void _onSearch(MedecinSearchChanged event, Emitter<MedecinState> emit) {
    final s = state;
    if (s is! MedecinLoaded) return;
    final q = event.query.toLowerCase().trim();
    final base = s.specialityActive == null
        ? s.tousLesdoctors
        : s.tousLesdoctors
              .where((d) => d.specialty == s.specialityActive)
              .toList();
    final filtres = q.isEmpty
        ? base
        : base
              .where(
                (d) =>
                    d.firstName.toLowerCase().contains(q) ||
                    d.lastName.toLowerCase().contains(q) ||
                    d.specialty.toLowerCase().contains(q) ||
                    d.city.toLowerCase().contains(q),
              )
              .toList();
    emit(s.copyWith(medecinsFiltres: filtres, searchQuery: event.query));
  }

  // ── Ouvrir détail médecin + charger disponibilités ───────────
  Future<void> _onDetailOuvert(
    MedecinDetailOuvert event,
    Emitter<MedecinState> emit,
  ) async {
    final s = state;
    if (s is! MedecinLoaded) return;

    emit(
      s.copyWith(
        medecinSelectionne: event.doctor,
        availibilitiesLoading: true,
        availibilities: [],
        clearDispo: true, // reset dispo sélectionnée
        rdvType: 'in_person',
      ),
    );

    try {
      final dispo = await _datasource.getDoctorsAvailibilities(
        event.doctor.doctorId,
      );
      log('Disponibilités: ${dispo.length}');
      emit(
        (state as MedecinLoaded).copyWith(
          availibilities: dispo,
          availibilitiesLoading: false,
        ),
      );
    } catch (e) {
      log('Disponibilités erreur: $e');
      emit((state as MedecinLoaded).copyWith(availibilitiesLoading: false));
    }
  }

  // ← NOUVEAU : patient clique sur une disponibilité
  void _onDisponibiliteSelectionnee(
    DisponibiliteSelectionnee event,
    Emitter<MedecinState> emit,
  ) {
    final s = state;
    if (s is! MedecinLoaded) return;
    emit(s.copyWith(disponibiliteSelectionnee: event.disponibilite));
  }

  // ── Type de consultation ──────────────────────────────────────
  void _onTypeSelectionne(
    RdvTypeSelectionne event,
    Emitter<MedecinState> emit,
  ) {
    final s = state;
    if (s is! MedecinLoaded) return;
    emit(s.copyWith(rdvType: event.type));
  }

  // ← CORRIGÉ : utilise la disponibilité sélectionnée
  Future<void> _onRdvConfirme(
    RdvConfirm event,
    Emitter<MedecinState> emit,
  ) async {
    final s = state;
    if (s is! MedecinLoaded) return;

    // Vérifier qu'une disponibilité est sélectionnée
    final dispo = s.disponibiliteSelectionnee;
    if (dispo == null) {
      emit(
        const MedecinError(message: 'Veuillez sélectionner une disponibilité.'),
      );
      return;
    }

    emit(RdvEnCours());
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const MedecinError(message: 'Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      final rdv = await _datasource.bookAppointment(
        patientId: patientId,
        doctorId: event.doctorId,
        disponibilite: dispo,
        type: event.type,
        reason: event.reason,
      );
      emit(RdvSucces(rdv));
    } catch (e) {
      log('RDV erreur: $e');
      emit(const MedecinError(message: 'Impossible de prendre le RDV.'));
    }
  }
}
