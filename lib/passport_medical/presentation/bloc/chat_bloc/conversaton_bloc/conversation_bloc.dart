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
    on<DocteursPourChatCharges>(_onChargerDocteurs); // ← nouveau
    on<NouvelleConversationDemandee>(_onNouvelleConversation); // ← nouveau
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

  // ── NOUVEAU : Charger médecins pour le choix ──────────────────
  Future<void> _onChargerDocteurs(
    DocteursPourChatCharges event,
    Emitter<ConversationState> emit,
  ) async {
    emit(DocteursPourChatChargement());
    try {
      final doctors = await _datasource.getDocteursPourChat();
      log('Médecins pour chat: ${doctors.length}');
      emit(DocteursPourChatLoaded(doctors));
    } catch (e) {
      log('Chargement médecins erreur: $e');
      emit(const ConversationErreur('Impossible de charger les médecins.'));
    }
  }

  // ── NOUVEAU : Créer ou récupérer une conversation ─────────────
  Future<void> _onNouvelleConversation(
    NouvelleConversationDemandee event,
    Emitter<ConversationState> emit,
  ) async {
    emit(NouvelleConversationChargement());
    try {
      final patient = await _datasource.getPatientConnecte();
      if (patient == null) {
        emit(const ConversationErreur('Profil patient introuvable.'));
        return;
      }
      final conv = await _datasource.creerOuRecupererConversation(
        patientId: patient.patientId,
        doctorId: event.doctorId,
      );
      log('Conversation prête: ${conv.id}');
      emit(ConversationCreee(conv));
    } catch (e) {
      log('Nouvelle conversation erreur: $e');
      emit(const ConversationErreur('Impossible de créer la conversation.'));
    }
  }
}
