import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/data/datasources/rdv_datasource.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/rdv_bloc/rdv_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/rdv_bloc/rdv_state.dart';

class RdvBloc extends Bloc<RdvEvent, RdvState> {
  final RdvDatasource _datasource;
  RdvBloc(this._datasource) : super(RdvInitialState()) {
    on<RdvDataLoaded>((event, emit) async {
      emit(RdvLoading());
      try {
        final patientConnected = await _datasource.getPatientConnecte();
        if (patientConnected == null) {
          emit(const RdvErreur(message: 'Profile patient introuvable'));
          return;
        }
        final patientId = patientConnected.patientId;
        final rdvs = await _datasource.getAppointments(patientId);
        emit(RdvLoaded(tousLesRdv: rdvs));
      } catch (e) {
        log('RdvBloc erreur :  $RdvErreur(message: e.toString())');
        emit(RdvErreur(message: 'Impossible de charger les rendez vous'));
      }
    });
    on<RdvRafraichies>(_onRafraichir);
  }

  Future<void> _onRafraichir(
    RdvRafraichies event,
    Emitter<RdvState> emit,
  ) async {
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const RdvErreur(message: 'Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      final rdvs = await _datasource.getAppointments(patientId);
      emit(RdvLoaded(tousLesRdv: rdvs));
    } catch (e) {
      log('RdvBloc erreur :  $RdvErreur(message: e.toString())');
      emit(RdvErreur(message: 'Impossible de charger les rendez vous'));
    }
  }
}
