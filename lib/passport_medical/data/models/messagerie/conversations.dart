// data/models/chat/conversation_model.dart

import 'package:equatable/equatable.dart';

class ConversationModel extends Equatable {
  final int id;
  final int doctorId;
  final int patientId;
  final DateTime lastMessageAt;

  // Depuis la jointure avec doctors
  final String medecinNom;
  final String medecinSpecialite;
  final String? medecinPhotoUrl;

  // Dernier message (jointure avec messages)
  final String? dernierMessage;
  final bool hasUnread;

  const ConversationModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.lastMessageAt,
    required this.medecinNom,
    required this.medecinSpecialite,
    this.medecinPhotoUrl,
    this.dernierMessage,
    this.hasUnread = false,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctors'] as Map<String, dynamic>? ?? {};

    // Dernier message depuis la jointure
    final messages = json['messages'] as List?;
    final dernierMsg = messages != null && messages.isNotEmpty
        ? messages.last['content'] as String?
        : null;

    // Vérifier si non lu
    final hasUnread = messages != null
        ? messages.any(
            (m) => m['is_read'] == false && m['sender_role'] == 'doctor',
          )
        : false;

    return ConversationModel(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      patientId: json['patient_id'] as int,
      lastMessageAt: DateTime.parse(json['last_message_at'] as String),
      medecinNom:
          'Dr. ${doctor['first_name'] ?? ''} '
          '${doctor['last_name'] ?? ''}',
      medecinSpecialite: doctor['specialty'] as String? ?? '',
      medecinPhotoUrl: doctor['photo_url'] as String?,
      dernierMessage: dernierMsg,
      hasUnread: hasUnread,
    );
  }

  @override
  List<Object?> get props => [id, doctorId, patientId, lastMessageAt];
}
