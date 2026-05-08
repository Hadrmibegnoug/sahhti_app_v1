import 'dart:async';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/messagerie/conversations.dart';
import '../models/messagerie/messages.dart';
import '../models/data_medical/patient.dart';
import '../models/medecin_rdv/doctors.dart';

class ChatDatasource {
  final SupabaseClient _client;
  ChatDatasource(this._client);

  // ── Patient connecté ─────────────────────────────────────────
  Future<PatientModel?> getPatientConnecte() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté.');
    final data = await _client
        .from('patients')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    log('Patient connecté: $data');
    if (data == null) return null;
    return PatientModel.fromJson(data);
  }

  // ── Liste des conversations ───────────────────────────────────
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
    log('Conversations: ${(data as List).length}');
    return (data).map((e) => ConversationModel.fromJson(e)).toList();
  }

  // ── NOUVEAU : Liste des médecins pour démarrer un chat ────────
  Future<List<DoctorsModel>> getDocteursPourChat() async {
    final data = await _client
        .from('doctors')
        .select()
        .order('rating', ascending: false);
    log('Médecins pour chat: ${(data as List).length}');
    return (data as List)
        .map((e) => DoctorsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── NOUVEAU : Créer ou récupérer une conversation ─────────────
  Future<ConversationModel> creerOuRecupererConversation({
    required int patientId,
    required int doctorId,
  }) async {
    // Chercher conversation existante
    final existing = await _client
        .from('conversations')
        .select('''
          *,
          doctors(first_name, last_name, specialty, photo_url),
          messages(content, is_read, sender_role, created_at)
        ''')
        .eq('patient_id', patientId)
        .eq('doctor_id', doctorId)
        .maybeSingle();

    if (existing != null) {
      log('Conversation existante trouvée');
      return ConversationModel.fromJson(existing);
    }

    // Créer une nouvelle conversation
    final created = await _client
        .from('conversations')
        .insert({
          'patient_id': patientId,
          'doctor_id': doctorId,
          'last_message_at': DateTime.now().toIso8601String(),
        })
        .select('''
          *,
          doctors(first_name, last_name, specialty, photo_url),
          messages(content, is_read, sender_role, created_at)
        ''')
        .single();

    log('Nouvelle conversation créée');
    return ConversationModel.fromJson(created);
  }

  // ── Messages d'une conversation ───────────────────────────────
  Future<List<MessageModel>> getMessages(int conversationId) async {
    final data = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    log('Messages: ${(data as List).length}');
    return (data).map((e) => MessageModel.fromJson(e)).toList();
  }

  // ── Envoyer un message ────────────────────────────────────────
  Future<MessageModel> sendMessage({
    required int conversationId,
    required int senderId,
    required String content,
  }) async {
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

    await _client
        .from('conversations')
        .update({'last_message_at': DateTime.now().toIso8601String()})
        .eq('id', conversationId);

    return MessageModel.fromJson(data);
  }

  // ── Marquer les messages comme lus ────────────────────────────
  Future<void> markAsRead(int conversationId) async {
    await _client
        .from('messages')
        .update({'is_read': true})
        .eq('conversation_id', conversationId)
        .eq('sender_role', 'doctor')
        .eq('is_read', false);
  }

  // ── Realtime ──────────────────────────────────────────────────
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
  }
}
