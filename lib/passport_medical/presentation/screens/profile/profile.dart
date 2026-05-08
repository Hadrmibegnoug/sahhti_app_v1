import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_alerts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../data/datasources/profile_datasource.dart';
import '../../../data/models/profile/profile_model.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/profile_bloc/profile_event.dart';
import '../../bloc/profile_bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProfileBloc(ProfileDatasource(Supabase.instance.client))
            ..add(ProfileCharge()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (ctx, state) {
        // Déconnexion réussie → login
        if (state is ProfileDeconnecte) {
          AppRouter.goAndClear(ctx, AppRoutes.login);
        }

        // Mise à jour réussie
        if (state is ProfileMisAJourSucces) {
          AppAlerts.succes(ctx, 'Profil mis à jour');
          // Recharger le profil
          ctx.read<ProfileBloc>().add(ProfileCharge());
        }

        // PIN changé
        if (state is ProfilePinSucces) {
          AppAlerts.succes(ctx, 'Code PIN changé avec succès');
        }

        // Erreur
        if (state is ProfileErreur) {
          AppAlerts.erreur(context, state.message);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileChargement) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final profile = state is ProfileLoaded
              ? state.profile
              : state is ProfileMisAJourSucces
              ? state.profile
              : null;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.primary,
              elevation: 0,
              title: const Text(
                'Mon Profil',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero ─────────────────────────────────────
                  _ProfilHero(profile: profile),
                  const SizedBox(height: 10),

                  // ── Informations personnelles ─────────────────
                  const _SectionLabel('INFORMATIONS PERSONNELLES'),
                  _CardData(
                    children: [
                      _RowInfo(
                        couleur: AppColors.primary.withOpacity(0.1),
                        icon: Icons.person,
                        iconColor: AppColors.primary,
                        title: 'Données Personnelles',
                        sousTitre: profile != null
                            ? '${profile.firstName} · '
                                  '${profile.gender == 'M' ? 'Masculin' : 'Féminin'} · '
                                  '${profile.dateOfBirth.year}-${profile.dateOfBirth.month}-${profile.dateOfBirth.day}'
                            : 'Nom · Sexe · Date de naissance',
                        onTap: () =>
                            _ouvrirDonneesPersonnelles(context, profile),
                      ),
                      _Divider(),
                      _RowInfo(
                        couleur: AppColors.error.withOpacity(0.1),
                        icon: Icons.water_drop_rounded,
                        iconColor: AppColors.error,
                        title: 'Données médicales de base',
                        sousTitre: profile != null
                            ? '${profile.bloodType} · Allergies · Antécédents'
                            : 'Groupe sanguin · Allergies · Antécédents',
                        onTap: () {},
                      ),
                      _Divider(),
                      _RowInfo(
                        couleur: Colors.amber.withOpacity(0.1),
                        icon: Icons.lock,
                        iconColor: Colors.amber[700]!,
                        title: 'Changer mon PIN',
                        sousTitre: 'Réinitialiser via ancien PIN',
                        onTap: () => _ouvrirChangerPin(context),
                      ),
                    ],
                  ),

                  // ── Préférences ───────────────────────────────
                  const _SectionLabel('PRÉFÉRENCES'),
                  _CardData(
                    children: [
                      _RowInfo(
                        couleur: Colors.blue.withOpacity(0.1),
                        icon: Icons.language_rounded,
                        iconColor: Colors.blue[800]!,
                        title: 'Langue',
                        sousTitre: 'Français / العربية',
                        onTap: () {},
                      ),
                      _Divider(),
                      _RowInfo(
                        couleur: Colors.yellow.withOpacity(0.15),
                        icon: Icons.notifications,
                        iconColor: Colors.yellow[800]!,
                        title: 'Rappels RDV',
                        sousTitre: 'Push + SMS · J-1 et H-2',
                        onTap: () {},
                      ),
                      _Divider(),
                      _RowInfo(
                        couleur: Colors.red.withOpacity(0.1),
                        icon: Icons.health_and_safety_outlined,
                        iconColor: Colors.red[800]!,
                        title: 'Rappels médicaments',
                        sousTitre: 'Traitements en cours',
                        onTap: () {},
                      ),
                      _Divider(),
                      _RowInfo(
                        couleur: Colors.grey.withOpacity(0.1),
                        icon: Icons.fingerprint,
                        iconColor: Colors.black87,
                        title: 'Biométrie',
                        sousTitre: 'Face ID / Empreinte digitale',
                        trailing: Switch(
                          value: false,
                          onChanged: (_) {},
                          activeColor: AppColors.primary,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),

                  // ── Sécurité & Données ────────────────────────
                  const _SectionLabel('SÉCURITÉ & DONNÉES'),
                  _CardData(
                    children: [
                      _RowInfo(
                        couleur: AppColors.primary.withOpacity(0.1),
                        icon: Icons.history,
                        iconColor: AppColors.primary,
                        title: "Historique d'accès",
                        sousTitre: 'Qui a consulté mon dossier',
                        onTap: () {},
                      ),
                      _Divider(),
                      _RowInfo(
                        couleur: AppColors.error.withOpacity(0.1),
                        icon: Icons.logout,
                        iconColor: AppColors.error,
                        title: 'Se déconnecter',
                        sousTitre: '',
                        showArrow: false,
                        trailing: state is ProfileChargement
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.error,
                                ),
                              )
                            : null,
                        onTap: () async {
                          final confirm = await AppAlerts.confirmation(
                            context,
                            titre: 'Se déconnecter',
                            message: 'Voulez-vous vraiment vous déconnecter ?',
                            labelConfirmer: 'Déconnecter',
                            dangereux: true,
                          );
                          if (confirm == true) {
                            context.read<ProfileBloc>().add(
                              ProfileDeconnexionDemandee(),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  // Version
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Sahhti v1.0.0 · صحتي',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Dialogue déconnexion ──────────────────────────────────────
  void _confirmerDeconnexion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Se déconnecter',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // ← ProfileBloc, pas AuthBloc
              context.read<ProfileBloc>().add(ProfileDeconnexionDemandee());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom sheet données personnelles ─────────────────────────
  void _ouvrirDonneesPersonnelles(BuildContext context, ProfileModel? profile) {
    if (profile == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: _SheetDonneesPersonnelles(profile: profile),
      ),
    );
  }

  // ── Bottom sheet changer PIN ──────────────────────────────────
  void _ouvrirChangerPin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: const _SheetChangerPin(),
      ),
    );
  }
}

// ── Hero profil ───────────────────────────────────────────────────
class _ProfilHero extends StatelessWidget {
  final ProfileModel? profile;
  const _ProfilHero({required this.profile});

  @override
  Widget build(BuildContext context) {
    final nom = profile?.nomComplet ?? 'Chargement...';
    final tel = profile?.phone ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 24, top: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundColor: AppColors.primary,
              child: Text(
                profile?.initiaux ?? '?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nom,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (tel.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                tel,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          const SizedBox(height: 14),
          if (profile != null)
            Wrap(
              spacing: 8,
              children: [
                _Badge(
                  label: profile!.bloodType,
                  icon: Icons.water_drop,
                  color: AppColors.error,
                ),
                if (profile!.gender != null)
                  _Badge(
                    label: profile!.gender == 'M' ? 'Masculin' : 'Féminin',
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  const _Badge({required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color ?? Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet données personnelles ─────────────────────────────────────
class _SheetDonneesPersonnelles extends StatefulWidget {
  final ProfileModel profile;
  const _SheetDonneesPersonnelles({required this.profile});

  @override
  State<_SheetDonneesPersonnelles> createState() =>
      _SheetDonneesPersonnellesState();
}

class _SheetDonneesPersonnellesState extends State<_SheetDonneesPersonnelles> {
  late final _firstNameCtrl = TextEditingController(
    text: widget.profile.firstName,
  );
  late final _lastNameCtrl = TextEditingController(
    text: widget.profile.lastName,
  );
  late final _phoneCtrl = TextEditingController(text: widget.profile.phone);

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _sauvegarder() {
    context.read<ProfileBloc>().add(
      ProfileMisAJour(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Données Personnelles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'NNI : ${widget.profile.nni}',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 20),

          _Champ(label: 'Prénom', controller: _firstNameCtrl),
          const SizedBox(height: 12),
          _Champ(label: 'Nom', controller: _lastNameCtrl),
          const SizedBox(height: 12),
          _Champ(
            label: 'Téléphone',
            controller: _phoneCtrl,
            clavier: TextInputType.phone,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sauvegarder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sauvegarder',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet changer PIN ─────────────────────────────────────────────
class _SheetChangerPin extends StatefulWidget {
  const _SheetChangerPin();

  @override
  State<_SheetChangerPin> createState() => _SheetChangerPinState();
}

class _SheetChangerPinState extends State<_SheetChangerPin> {
  final _ancienCtrl = TextEditingController();
  final _nouveauCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _ancienCtrl.dispose();
    _nouveauCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _changer() {
    if (_nouveauCtrl.text != _confirmCtrl.text) {
      AppAlerts.erreur(context, 'Les codes ne correspondent pas.');
      return;
    }
    if (_ancienCtrl.text.length < 4 || _nouveauCtrl.text.length < 4) {
      AppAlerts.erreur(context, 'Le code doit contenir au moins 4 chiffres.');
      return;
    }
    context.read<ProfileBloc>().add(
      ProfilePinChange(
        ancienPin: _ancienCtrl.text,
        nouveauPin: _nouveauCtrl.text,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Changer le code PIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          _Champ(
            label: 'Ancien PIN (4 chiffres)',
            controller: _ancienCtrl,
            clavier: TextInputType.number,
            obscure: true,
            maxLen: 4,
          ),
          const SizedBox(height: 12),
          _Champ(
            label: 'Nouveau PIN (4 chiffres)',
            controller: _nouveauCtrl,
            clavier: TextInputType.number,
            obscure: true,
            maxLen: 4,
          ),
          const SizedBox(height: 12),
          _Champ(
            label: 'Confirmer le nouveau PIN',
            controller: _confirmCtrl,
            clavier: TextInputType.number,
            obscure: true,
            maxLen: 4,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _changer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Changer le PIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets partagés dans ce fichier ─────────────────────────────────
class _Champ extends StatelessWidget {
  final String controller_label = '';
  final String label;
  final TextEditingController controller;
  final TextInputType clavier;
  final bool obscure;
  final int? maxLen;

  const _Champ({
    required this.label,
    required this.controller,
    this.clavier = TextInputType.text,
    this.obscure = false,
    this.maxLen,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: clavier,
      obscureText: obscure,
      maxLength: maxLen,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _CardData extends StatelessWidget {
  final List<Widget> children;
  const _CardData({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(color: Colors.grey.shade100, height: 1, thickness: 1);
}

class _RowInfo extends StatelessWidget {
  final Color couleur;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String sousTitre;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const _RowInfo({
    required this.couleur,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.sousTitre,
    this.trailing,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: couleur,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sousTitre.isNotEmpty)
                    Text(
                      sousTitre,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (showArrow
                    ? Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                        size: 20,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
