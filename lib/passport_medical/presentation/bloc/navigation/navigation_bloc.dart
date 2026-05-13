import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_state.dart';

import '../../../data/datasources/profile_datasource.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final ProfileDatasource _datasource;
  NavigationBloc(this._datasource)
    : super(const NavigationActive(indexActuel: 0)) {
    on<NavigationOngletChange>(_ongletChange);
    on<ProfileChargeNav>(_onChargerProfile);
  }

  void _ongletChange(
    NavigationOngletChange event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationActive(indexActuel: event.index));
  }

  Future<void> _onChargerProfile(
    ProfileChargeNav event,
    Emitter<NavigationState> emit,
  ) async {
    emit(NavigationChargement());
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(NavigationErreur('Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      final profile = await _datasource.getProfile(patientId);
      if (profile == null) {
        log("****TabScreen****");
        log("message: Profil introuvable pour patientId: $patientId");
        emit(NavigationErreur('Profil introuvable.'));
      } else {
        log("********");
        log("message: Profil chargé avec succès pour patientId: $patientId");
        emit(ProfileLoadedNav(profile));
      }
    } catch (e) {
      log('ProfileBloc chargement erreur: $e');
      emit(NavigationErreur(e.toString()));
    }
  }
}
