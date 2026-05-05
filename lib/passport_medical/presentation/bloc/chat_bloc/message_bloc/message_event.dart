import 'package:equatable/equatable.dart';

import '../../../../data/models/messagerie/messages.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
  @override List<Object?> get props => [];
}

// Ouvrir une conversation
class MessagesCharges extends MessageEvent {
  final int conversationId;
  const MessagesCharges({
    required this.conversationId,
  });
  @override List<Object> get props => [conversationId];
}

// Envoyer un message
class MessageEnvoye extends MessageEvent {
  final int    conversationId;
  final String content;
  const MessageEnvoye({
    required this.conversationId,
    required this.content,
  });
  @override List<Object> get props => [conversationId, content];
}

// Nouveau message reçu via Realtime
class NouveauMessageRecu extends MessageEvent {
  final MessageModel message;
  const NouveauMessageRecu(this.message);
  @override List<Object> get props => [message];
}