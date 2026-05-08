import 'package:equatable/equatable.dart';
import 'package:sahha_pass/passport_medical/data/models/messagerie/conversations.dart';

import '../../../../data/models/medecin_rdv/doctors.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();
  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationChargement extends ConversationState {}

// ← NOUVEAU : médecins chargés pour le choix
class DocteursPourChatChargement extends ConversationState {}

class DocteursPourChatLoaded extends ConversationState {
  final List<DoctorsModel> doctors;
  const DocteursPourChatLoaded(this.doctors);
  @override
  List<Object> get props => [doctors];
}

class ConversationLoaded extends ConversationState {
  final List<ConversationModel> conversations;
  const ConversationLoaded(this.conversations);
  @override
  List<Object> get props => [conversations];
}

// ← NOUVEAU : conversation créée → navigation vers chat
class ConversationCreee extends ConversationState {
  final ConversationModel conversation;
  const ConversationCreee(this.conversation);
  @override
  List<Object> get props => [conversation];
}

class ConversationErreur extends ConversationState {
  final String message;
  const ConversationErreur(this.message);
  @override
  List<Object> get props => [message];
}

class NouvelleConversationChargement extends ConversationState {}
