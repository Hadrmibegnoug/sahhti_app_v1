// data/models/chat/message_model.dart

import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderRole; // 'patient' | 'doctor'
  final String content;
  final String? attachmentUrl;
  final bool isRead;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderRole,
    required this.content,
    this.attachmentUrl,
    required this.isRead,
    required this.createdAt,
  });

  // Calculé localement
  bool get isFromPatient => senderRole == 'patient';

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      senderId: json['sender_id'] as int,
      senderRole: json['sender_role'] as String,
      content: json['content'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, conversationId, senderId, createdAt];
}
