import 'package:equatable/equatable.dart';

import '../../../../data/models/messagerie/messages.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageChargement extends MessageState {}

class MessageEnvoi extends MessageState {} // spinner pendant envoi

class MessageLoaded extends MessageState {
  final List<MessageModel> messages;
  final bool envoiEnCours;

  const MessageLoaded({required this.messages, this.envoiEnCours = false});

  MessageLoaded copyWith({List<MessageModel>? messages, bool? envoiEnCours}) {
    return MessageLoaded(
      messages: messages ?? this.messages,
      envoiEnCours: envoiEnCours ?? this.envoiEnCours,
    );
  }

  @override
  List<Object> get props => [messages, envoiEnCours];
}

class MessageErreur extends MessageState {
  final String message;
  const MessageErreur(this.message);
  @override
  List<Object> get props => [message];
}
