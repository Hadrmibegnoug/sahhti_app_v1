// presentation/screens/chat/chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/models/messagerie/conversations.dart';
import '../../../data/models/messagerie/messages.dart';
import '../../bloc/chat_bloc/message_bloc/message_bloc.dart';
import '../../bloc/chat_bloc/message_bloc/message_event.dart';
import '../../bloc/chat_bloc/message_bloc/message_state.dart';

class ChatPage extends StatelessWidget {
  final ConversationModel conversation;
  const ChatPage({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MessageBloc(ChatDatasource(Supabase.instance.client))
            ..add(MessagesCharges(conversationId: conversation.id)),
      child: _ChatView(conversation: conversation),
    );
  }
}

class _ChatView extends StatelessWidget {
  final ConversationModel conversation;
  const _ChatView({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatAppBar(conversation: conversation),
      body: Column(
        children: [
          // ── Liste des messages ───────────────────────────
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageChargement) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MessageErreur) {
                  return Center(child: Text(state.message));
                }
                if (state is MessageLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun message.\nEnvoyez le premier !',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return _MessagesList(messages: state.messages);
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // ── Zone de saisie ───────────────────────────────
          _InputBar(conversationId: conversation.id),
        ],
      ),
    );
  }
}

// ── AppBar avec infos médecin ─────────────────────────────────────
class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ConversationModel conversation;
  const _ChatAppBar({required this.conversation});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      leadingWidth: 30,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withOpacity(0.3),
            backgroundImage: conversation.medecinPhotoUrl != null
                ? NetworkImage(conversation.medecinPhotoUrl!)
                : null,
            child: conversation.medecinPhotoUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                conversation.medecinNom,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                conversation.medecinSpecialite,
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Liste des messages ────────────────────────────────────────────
class _MessagesList extends StatefulWidget {
  final List<MessageModel> messages;
  const _MessagesList({required this.messages});

  @override
  State<_MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<_MessagesList> {
  final _scrollCtrl = ScrollController();

  // _MessagesListState — ajouter initState

  @override
  void initState() {
    super.initState();
    // Scroll en bas au premier chargement
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    }
  }

  @override
  void didUpdateWidget(covariant _MessagesList old) {
    super.didUpdateWidget(old);
    // Scroll automatique vers le bas quand un nouveau message arrive
    if (widget.messages.length != old.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final msg = widget.messages[index];

        // Afficher la date si c'est un nouveau jour
        final showDate =
            index == 0 ||
            !_memeJour(widget.messages[index - 1].createdAt, msg.createdAt);

        return Column(
          children: [
            if (showDate) _DateSeparator(date: msg.createdAt),
            _MessageBubble(message: msg),
          ],
        );
      },
    );
  }

  bool _memeJour(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// ── Séparateur date ───────────────────────────────────────────────
class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final label = d == today
        ? "Aujourd'hui"
        : d == today.subtract(const Duration(days: 1))
        ? 'Hier'
        : '${date.day}/${date.month}/${date.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade200)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade200)),
        ],
      ),
    );
  }
}

// ── Bulle de message ──────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isPatient = message.isFromPatient;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: isPatient
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar médecin (gauche)
          if (!isPatient) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.person, color: AppColors.primary, size: 14),
            ),
            const SizedBox(width: 6),
          ],

          // Bulle
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isPatient ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isPatient ? 18 : 4),
                  bottomRight: Radius.circular(isPatient ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPatient ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatHeure(message.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isPatient ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      // Indicateur lu/non lu (seulement pour les messages du patient)
                      if (isPatient) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 13,
                          color: message.isRead ? Colors.white : Colors.white60,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHeure(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}

// ── Zone de saisie ────────────────────────────────────────────────
// Le seul StatefulWidget restant dans le chat = TextEditingController

class _InputBar extends StatefulWidget {
  final int conversationId;
  const _InputBar({required this.conversationId});
  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  // ← SEULE RAISON d'être StatefulWidget
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _envoyer() {
    final content = _ctrl.text.trim();
    if (content.isEmpty) return;
    context.read<MessageBloc>().add(
      MessageEnvoye(
        conversationId: widget.conversationId,
        content: content,
      ),
    );
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _ctrl,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Votre message...',
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // ← _hasText dérivé depuis le controller directement
            // via ValueListenableBuilder — pas de setState
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _ctrl,
              builder: (ctx, value, _) {
                final hasText = value.text.trim().isNotEmpty;
                return BlocBuilder<MessageBloc, MessageState>(
                  builder: (ctx, state) {
                    final loading =
                        state is MessageLoaded && state.envoiEnCours;
                    return GestureDetector(
                      onTap: hasText && !loading ? _envoyer : null,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: hasText
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: loading
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
