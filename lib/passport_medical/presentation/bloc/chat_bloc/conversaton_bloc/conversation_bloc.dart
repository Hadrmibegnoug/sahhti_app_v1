import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/data/datasources/chat_datasource.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/chat_bloc/conversaton_bloc/conversation_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/chat_bloc/conversaton_bloc/conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ChatDatasource _datasource;
  ConversationBloc(this._datasource) : super(ConversationInitial()) {
    on<ConversationsChargees>(_onCharger);
    on<ConversationsRefraichies>(_onRafraichir);
  }

  Future<void> _onCharger(
    ConversationsChargees event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationChargement());
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const ConversationErreur('Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      final convs = await _datasource.getConversations(patientId);
      log('Conversations chargées: ${convs.length} conversations}');
      emit(ConversationLoaded(convs));
    } catch (e) {
      log('Conversation Bloc erreur: $e');
      emit(ConversationErreur('Impossible de charger les messages.'));
    }
  }

  Future<void> _onRafraichir(
    ConversationsRefraichies event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const ConversationErreur('Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;
      final convs = await _datasource.getConversations(patientId);
      emit(ConversationLoaded(convs));
    } catch (e) {
      log("Conversation Bloc Raffraichissement erreur: $e");
    }
  }
}
