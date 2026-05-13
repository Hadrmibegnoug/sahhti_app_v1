// presentation/screens/chat/choix_medecin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_alerts.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/data/datasources/chat_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/medecin_rdv/doctors.dart';
import '../../bloc/chat_bloc/conversaton_bloc/conversation_bloc.dart';
import '../../bloc/chat_bloc/conversaton_bloc/conversation_event.dart';
import '../../bloc/chat_bloc/conversaton_bloc/conversation_state.dart';
import 'chat_page.dart';
import 'package:sahha_pass/l10n/build_context_l10n.dart';

class ChoixMedecinPage extends StatelessWidget {
  const ChoixMedecinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConversationBloc(ChatDatasource(Supabase.instance.client))
            ..add(DocteursPourChatCharges()),
      child: MedecinPageCharges(),
    );
  }
}

class MedecinPageCharges extends StatelessWidget {
  const MedecinPageCharges({super.key});
  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationCreee) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ConversationBloc>(),
                child: ChatPage(conversation: state.conversation),
              ),
            ),
          );
        }
        if (state is ConversationErreur) {
          AppAlerts.erreur(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            t.contacterMedecin,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is DocteursPourChatChargement) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NouvelleConversationChargement) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      t.ouvertureConversation,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // ← Médecins chargés — afficher la liste
            if (state is DocteursPourChatLoaded) {
              if (state.doctors.isEmpty) {
                return Center(
                  child: Text(
                    t.aucunMedecinTrouve,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return _ListeMedecins(doctors: state.doctors);
            }

            // Erreur
            if (state is ConversationErreur) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ConversationBloc>().add(
                        const DocteursPourChatCharges(),
                      ),
                      child: Text(t.reessayer),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Liste des médecins ────────────────────────────────────────────
class _ListeMedecins extends StatelessWidget {
  final List<DoctorsModel> doctors;
  const _ListeMedecins({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: doctors.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) => _MedecinTile(doctor: doctors[index]),
    );
  }
}

// ── Tile médecin ──────────────────────────────────────────────────
class _MedecinTile extends StatelessWidget {
  final DoctorsModel doctor;
  const _MedecinTile({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<ConversationBloc>().add(
        NouvelleConversationDemandee(doctor.doctorId),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: doctor.imageUrl.isNotEmpty
                  ? NetworkImage(doctor.imageUrl)
                  : null,
              child: doctor.imageUrl.isEmpty
                  ? Text(
                      _initiale(doctor.nomComplet),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.nomComplet,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doctor.specialty,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        doctor.city,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Icône message
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initiale(String nom) {
    final parts = nom
        .replaceAll('Dr. ', '')
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : parts[0][0].toUpperCase();
  }
}
