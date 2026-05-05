import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctor_availabilities.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctors.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/medecin_bloc/medecin_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/medecin_bloc/medecin_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/medecin_bloc/medecin_state.dart';

import '../../../data/models/messagerie/conversations.dart';

class MedecinDetailPage extends StatelessWidget {
  final DoctorsModel doctor;
  final ConversationModel? conversation;
  const MedecinDetailPage({super.key, required this.doctor, this.conversation});

  @override
  Widget build(BuildContext context) {
    context.read<MedecinBloc>().add(MedecinDetailOuvert(doctor));

    return BlocListener<MedecinBloc, MedecinState>(
      listener: (ctx, state) {
        if (state is RdvSucces) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('RDV confirmé avec ${doctor.nomComplet} ✓'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is MedecinError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(doctor.nomComplet),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<MedecinBloc, MedecinState>(
          builder: (context, state) {
            if (state is! MedecinLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profil médecin ─────────────────────────
                  _ProfilHeader(doctor: doctor),
                  const SizedBox(height: 20),

                  // ── Bio ────────────────────────────────────
                  _InfoCard(doctor: doctor),
                  const SizedBox(height: 20),

                  // ── Disponibilités cliquables ──────────────
                  const Text(
                    'Choisir une disponibilité',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  state.availibilitiesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.availibilities.isEmpty
                      ? const Text(
                          'Aucune disponibilité.',
                          style: TextStyle(color: Colors.grey),
                        )
                      : _DisponibilitesList(
                          availabilities: state.availibilities,
                          selectionnee: state.disponibiliteSelectionnee,
                        ),

                  const SizedBox(height: 20),

                  // ── Type de consultation ───────────────────
                  const Text(
                    'Type de consultation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _TypeChip(
                        label: 'Présentiel',
                        icon: Icons.person,
                        selected: state.rdvType == 'in_person',
                        onTap: () => context.read<MedecinBloc>().add(
                          const RdvTypeSelectionne('in_person'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _TypeChip(
                        label: 'Téléconsultation',
                        icon: Icons.video_call,
                        selected: state.rdvType == 'teleconsult',
                        onTap: () => context.read<MedecinBloc>().add(
                          const RdvTypeSelectionne('teleconsult'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Motif + Confirmer ──────────────────────
                  // StatefulWidget légitime : TextEditingController
                  _MotifEtConfirmer(
                    disponibiliteSelectionnee: state.disponibiliteSelectionnee,
                    onConfirm: (reason) {
                      if (state.disponibiliteSelectionnee == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Veuillez sélectionner une disponibilité.',
                            ),
                          ),
                        );
                        return;
                      }
                      context.read<MedecinBloc>().add(
                        RdvConfirm(
                          doctorId: doctor.doctorId,
                          type: state.rdvType,
                          reason: reason,
                        ),
                      );
                    },
                    isLoading: state is RdvEnCours,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Liste des disponibilités cliquables ───────────────────────────
class _DisponibilitesList extends StatelessWidget {
  final List<DoctorAvailabilitiesModel> availabilities;
  final DoctorAvailabilitiesModel? selectionnee;

  const _DisponibilitesList({
    required this.availabilities,
    required this.selectionnee,
  });

  String _traduireJour(String day) {
    const jours = {
      'monday': 'Lundi',
      'lundi': 'Lundi',
      'tuesday': 'Mardi',
      'mardi': 'Mardi',
      'wednesday': 'Mercredi',
      'mercredi': 'Mercredi',
      'thursday': 'Jeudi',
      'jeudi': 'Jeudi',
      'friday': 'Vendredi',
      'vendredi': 'Vendredi',
      'saturday': 'Samedi',
      'samedi': 'Samedi',
      'sunday': 'Dimanche',
      'dimanche': 'Dimanche',
    };
    return jours[day.toLowerCase()] ?? day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: availabilities.map((dispo) {
        final estSelectionnee =
            selectionnee?.dayOfWeek == dispo.dayOfWeek &&
            selectionnee?.startTime == dispo.startTime;

        return GestureDetector(
          onTap: () =>
              context.read<MedecinBloc>().add(DisponibiliteSelectionnee(dispo)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: estSelectionnee
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: estSelectionnee
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.2),
                width: estSelectionnee ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icône sélection
                Icon(
                  estSelectionnee
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: estSelectionnee ? Colors.white : AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),

                // Jour
                SizedBox(
                  width: 90,
                  child: Text(
                    _traduireJour(dispo.dayOfWeek),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: estSelectionnee ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),

                // Horaires
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: estSelectionnee ? Colors.white70 : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${dispo.startTime} – ${dispo.endTime}',
                  style: TextStyle(
                    fontSize: 13,
                    color: estSelectionnee ? Colors.white : Colors.black87,
                  ),
                ),

                const Spacer(),

                // Durée créneau
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: estSelectionnee
                        ? Colors.white.withOpacity(0.25)
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${dispo.slotDurationMinutes} min',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Profil header ─────────────────────────────────────────────────
class _ProfilHeader extends StatelessWidget {
  final DoctorsModel doctor;
  const _ProfilHeader({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            child: ClipOval(
              child: Image.network(
                doctor.imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, size: 50, color: AppColors.background),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            doctor.nomComplet,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '${doctor.specialty} · ${doctor.city}',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                doctor.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.attach_money, size: 16, color: Colors.green),
              Text(
                '${doctor.consultationFee.toInt()} MRU',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Info card bio ────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final DoctorsModel doctor;
  const _InfoCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'À propos',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.bio,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Type chip ─────────────────────────────────────────────────────
class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Motif + bouton confirmer ──────────────────────────────────────
// StatefulWidget légitime : uniquement pour TextEditingController
class _MotifEtConfirmer extends StatefulWidget {
  final DoctorAvailabilitiesModel? disponibiliteSelectionnee;
  final void Function(String reason) onConfirm;
  final bool isLoading;

  const _MotifEtConfirmer({
    required this.disponibiliteSelectionnee,
    required this.onConfirm,
    required this.isLoading,
  });

  @override
  State<_MotifEtConfirmer> createState() => _MotifEtConfirmerState();
}

class _MotifEtConfirmerState extends State<_MotifEtConfirmer> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Résumé de la disponibilité sélectionnée
        if (widget.disponibiliteSelectionnee != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${widget.disponibiliteSelectionnee!.dayOfWeek} · '
                    '${widget.disponibiliteSelectionnee!.startTime} – '
                    '${widget.disponibiliteSelectionnee!.endTime}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Motif
        const Text(
          'Motif de consultation',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _ctrl,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Décrivez brièvement votre motif...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Bouton confirmer
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              // Désactivé si aucune dispo sélectionnée
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                widget.isLoading || widget.disponibiliteSelectionnee == null
                ? null
                : () => widget.onConfirm(_ctrl.text.trim()),
            child: widget.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    widget.disponibiliteSelectionnee == null
                        ? 'Sélectionnez une disponibilité'
                        : 'Confirmer le rendez-vous',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
