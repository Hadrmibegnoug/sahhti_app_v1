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

// ← NOUVEAU : charger les médecins pour le choix
class DocteursPourChatCharges extends ConversationEvent {
  const DocteursPourChatCharges();
}

// ← NOUVEAU : patient veut démarrer une conversation avec un médecin
class NouvelleConversationDemandee extends ConversationEvent {
  final int doctorId;
  const NouvelleConversationDemandee(this.doctorId);
  @override
  List<Object> get props => [doctorId];
}
