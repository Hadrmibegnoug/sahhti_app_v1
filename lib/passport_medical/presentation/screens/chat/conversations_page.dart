import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import '../../../data/datasources/chat_datasource.dart';
import '../../../data/models/messagerie/conversations.dart';
import '../../bloc/chat_bloc/conversaton_bloc/conversation_bloc.dart';
import '../../bloc/chat_bloc/conversaton_bloc/conversation_event.dart';
import '../../bloc/chat_bloc/conversaton_bloc/conversation_state.dart';
import 'chat_page.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConversationBloc(ChatDatasource(Supabase.instance.client))
            ..add(ConversationsChargees()),
      child: const _ConversationsView(),
    );
  }
}

class _ConversationsView extends StatelessWidget {
  const _ConversationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationChargement) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ConversationErreur) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ConversationBloc>().add(
                      const ConversationsChargees(),
                    ),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is ConversationLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aucune conversation',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Prenez un RDV pour contacter\nun médecin',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => context.read<ConversationBloc>().add(
                const ConversationsRefraichies(),
              ),
              child: ListView.separated(
                itemCount: state.conversations.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final conv = state.conversations[index];
                  return _ConversationTile(conversation: conv);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatPage(conversation: conversation),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // ── Avatar médecin ────────────────────────────
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  backgroundImage: conversation.medecinPhotoUrl != null
                      ? NetworkImage(conversation.medecinPhotoUrl!)
                      : null,
                  child: conversation.medecinPhotoUrl == null
                      ? Text(
                          conversation.medecinNom
                              .replaceAll('Dr. ', '')
                              .split(' ')
                              .map((e) => e.isNotEmpty ? e[0] : '')
                              .take(2)
                              .join(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                // Point rouge si non lu
                if (conversation.hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // ── Infos conversation ─────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.medecinNom,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: conversation.hasUnread
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      Text(
                        _formatDate(conversation.lastMessageAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: conversation.hasUnread
                              ? AppColors.primary
                              : Colors.grey,
                          fontWeight: conversation.hasUnread
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.dernierMessage ??
                              'Commencer la conversation',
                          style: TextStyle(
                            fontSize: 12,
                            color: conversation.hasUnread
                                ? Colors.black87
                                : Colors.grey,
                            fontWeight: conversation.hasUnread
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Badge non lu
                      if (conversation.hasUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Nouveau',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation.medecinSpecialite,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    return '${d.day}/${d.month}';
  }
}
