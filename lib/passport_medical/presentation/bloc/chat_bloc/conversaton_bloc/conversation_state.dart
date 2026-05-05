import 'package:equatable/equatable.dart';
import 'package:sahha_pass/passport_medical/data/models/messagerie/conversations.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();
  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationChargement extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<ConversationModel> conversations;
  const ConversationLoaded(this.conversations);
  @override
  List<Object> get props => [conversations];
}

class ConversationErreur extends ConversationState {
  final String message;
  const ConversationErreur(this.message);
  @override
  List<Object> get props => [message];
}
