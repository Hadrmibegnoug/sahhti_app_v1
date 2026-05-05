// presentation/bloc/chat_bloc/message_bloc.dart

import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/datasources/chat_datasource.dart';
import '../../../../data/models/messagerie/messages.dart';
import 'message_event.dart';

import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatDatasource _datasource;
  StreamSubscription<MessageModel>? _realtimeSub;
  RealtimeChannel? _channel;

  MessageBloc(this._datasource) : super(MessageInitial()) {
    on<MessagesCharges>(_onCharger);
    on<MessageEnvoye>(_onEnvoyer);
    on<NouveauMessageRecu>(_onNouveauMessage);
  }

  // Dans _demarrerRealtime — modifier
  void _demarrerRealtime(int conversationId) {
    _realtimeSub?.cancel();

    _realtimeSub = _datasource
        .listenToMessages(conversationId)
        .listen(
          (message) => add(NouveauMessageRecu(message)),
          onError: (e) => log('Realtime erreur: $e'),
        );
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    Supabase.instance.client.removeAllChannels(); // ← libérer les channels
    return super.close();
  }

  // ── Charger les messages + démarrer Realtime ──────────────────
  Future<void> _onCharger(
    MessagesCharges event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageChargement());

    try {
      // 1. Charger les messages existants
      final messages = await _datasource.getMessages(event.conversationId);
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const MessageErreur('Profile patient introuvable'));
        return;
      }
      final patientId = patientConnected.patientId;

      // 2. Marquer comme lus
      await _datasource.markAsRead(event.conversationId, patientId);

      emit(MessageLoaded(messages: messages));

      // 3. Démarrer l'écoute Realtime
      _demarrerRealtime(event.conversationId);
    } catch (e) {
      log('MessageBloc erreur: $e');
      emit(MessageErreur('Impossible de charger les messages.'));
    }
  }

  // ── Envoyer un message ────────────────────────────────────────
  Future<void> _onEnvoyer(
    MessageEnvoye event,
    Emitter<MessageState> emit,
  ) async {
    final s = state;
    if (s is! MessageLoaded) return;

    // Afficher un indicateur d'envoi sans bloquer l'UI
    emit(s.copyWith(envoiEnCours: true));

    try {
      // Le message envoyé sera reçu via Realtime
      // donc pas besoin de l'ajouter manuellement ici
      final patientConnected = await _datasource.getPatientConnecte();
      if (patientConnected == null) {
        emit(const MessageErreur('Profile patient introuvable'));
        return;
      }
      final senderId = patientConnected.patientId;
      await _datasource.sendMessage(
        conversationId: event.conversationId,
        senderId: senderId,
        content: event.content,
      );
      emit(s.copyWith(envoiEnCours: false));
    } catch (e) {
      log('Envoi erreur: $e');
      emit(s.copyWith(envoiEnCours: false));
    }
  }

  // ── Nouveau message via Realtime ──────────────────────────────
  void _onNouveauMessage(NouveauMessageRecu event, Emitter<MessageState> emit) {
    final s = state;
    if (s is! MessageLoaded) return;

    // Éviter les doublons
    final dejaDans = s.messages.any((m) => m.id == event.message.id);
    if (dejaDans) return;

    emit(s.copyWith(messages: [...s.messages, event.message]));
  }

  // // ── Démarrer l'écoute Realtime ────────────────────────────────
  // void _demarrerRealtime(int conversationId) {
  //   _realtimeSub?.cancel(); // annuler l'ancienne subscription si elle existe

  //   _realtimeSub = _datasource.listenToMessages(conversationId).listen((
  //     message,
  //   ) {
  //     log('Realtime — nouveau message: ${message.content}');
  //     add(NouveauMessageRecu(message));
  //   }, onError: (e) => log('Realtime erreur: $e'));
  // }

  // // ── Fermer le BLoC — IMPORTANT pour libérer le Stream ────────
  // @override
  // Future<void> close() {
  //   _realtimeSub?.cancel();
  //   return super.close();
  // }
}
