import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
  @override
  List<Object?> get props => [];
}

// Page s'ouvre - charger les conversations
class ConversationsChargees extends ConversationEvent {
  const ConversationsChargees();
  @override
  List<Object> get props => [];
}

// Après avoir envoyé/reçu un message - refraichir
class ConversationsRefraichies extends ConversationEvent {
  const ConversationsRefraichies();
  @override
  List<Object> get props => [];
}
