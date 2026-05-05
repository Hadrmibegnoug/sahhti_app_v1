import 'dart:async';
import 'dart:developer';

import 'package:sahha_pass/passport_medical/data/models/messagerie/conversations.dart';
import 'package:sahha_pass/passport_medical/data/models/messagerie/messages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/data_medical/patient.dart';

class ChatDatasource {
  final SupabaseClient _client;
  ChatDatasource(this._client);

  // --Liste des conversations du patient ------------
  Future<List<ConversationModel>> getConversations(int patientId) async {
    final data = await _client
        .from('conversations')
        .select('''
    *,
    doctors(first_name, last_name, specialty, photo_url),
    messages(content, is_read, sender_role, created_at)
''')
        .eq('patient_id', patientId)
        .order('last_message_at', ascending: false);
    log('Conversations: $data');
    return (data as List)
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // --Messages d'une conversation -----------------
  Future<List<MessageModel>> getMessages(int conversationId) async {
    final data = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    log('Messages conversation $conversationId: ${data.length} messages');
    return (data as List)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -- Envoyer un message --------------------------
  Future<MessageModel> sendMessage({
    required int conversationId,
    required int senderId,
    required String content,
  }) async {
    // Insérer le message
    final data = await _client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': senderId,
          'sender_role': 'patient',
          'content': content,
          'is_read': false,
        })
        .select()
        .single();
    // Mise à jour last_message_at dans conversations
    await _client
        .from('conversations')
        .update({'last_message_at': DateTime.now().toIso8601String()})
        .eq('id', conversationId);
    return MessageModel.fromJson(data);
  }

  // -- Marquer les messages comme lus ------------------
  Future<void> markAsRead(int conversationId, int patientId) async {
    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .eq('sender_role', 'doctor') // marquer seulement du médecin
        .eq('is_read', false);
  }

  // -- Realtime - écouter les nouveaux messages----------------
  Stream<MessageModel> listenToMessages(int conversationId) {
    final controller = StreamController<MessageModel>.broadcast();
    _client
        .channel('messages_conv_$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final msg = MessageModel.fromJson(payload.newRecord);
            controller.add(msg);
          },
        )
        .subscribe();

    return controller.stream;
    // .from('messages')
    // .stream(primaryKey: ['ide'])
    // .eq('conversation_id', conversationId)
    // .order('created_at')
    // .map((data) {
    //   if (data.isEmpty) return null;
    //   return MessageModel.fromJson(data.last);
    // })
    // .where((msg) => msg != null)
    // .cast<MessageModel>();
  }

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
