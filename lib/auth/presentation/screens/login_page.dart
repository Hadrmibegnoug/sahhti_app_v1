import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sahha_pass/core/constants/app_alerts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/locale_service.dart';
import '../../data/datasource/auth_datasource.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widget/champ_telephone.dart';
import 'package:sahha_pass/l10n/build_context_l10n.dart';

class LoginPage extends StatelessWidget {
  final LocaleService localeService;
  const LoginPage({super.key, required this.localeService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(AuthDatasource(Supabase.instance.client))
            ..add(PinConnexionInitialise()),
      child: _LoginView(localeService: localeService),
    );
  }
}

// ← StatefulWidget UNIQUEMENT pour TextEditingController
class _LoginView extends StatefulWidget {
  const _LoginView({required this.localeService});
  final LocaleService localeService;
  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthConnecte) {
          AppRouter.goAndClear(ctx, AppRoutes.home);
        }
        if (state is AuthErreur) {
          // Réinitialiser le PIN
          ctx.read<AuthBloc>().add(PinConnexionInitialise());
          AppAlerts.erreur(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  "assets/images/logo.png",
                  // width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,

                  //alignment: Alignment.topCenter,
                ),
                const SizedBox(height: 25),

                // Téléphone — StatefulWidget car TextEditingController
                ChampTelephone(
                  obscureText: false,
                  controller: _phoneCtrl,
                  label: t.tel,
                  keyboard: .phone,
                  icon: Icon(
                    Icons.phone_android_rounded,
                    color: AppColors.primary,
                  ),
                  hintText: 'XX XX XX XX',
                ),
                const SizedBox(height: 20),
                ChampTelephone(
                  obscureText: true,
                  controller: _pinCtrl,
                  keyboard: .phone,
                  label: t.pin,
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                  ),
                  hintText: "****",
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    final isLoading = state is AuthChargement;
                    return ElevatedButton(
                      onPressed: () {
                        isLoading
                            ? null
                            : ctx.read<AuthBloc>().add(
                                ConnexionDemandee(
                                  telephone: _phoneCtrl.text.trim(),
                                  pin: _pinCtrl.text.trim(),
                                ),
                              );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              t.connexion,
                              style: TextStyle(
                                color: AppColors.background,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    );
                  },
                ),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        AppRouter.goTo(context, AppRoutes.registerNni),
                    child: Text(
                      t.pasEncoreInscrit,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _RowInfoAvecSwitch(
                  couleur: AppColors.primary.withOpacity(0.1),
                  icon: PhosphorIconsRegular.globe,
                  iconColor: AppColors.primary,
                  title: t.langue,
                  child: _SwitchLangue(localeService: widget.localeService),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchLangue extends StatelessWidget {
  final LocaleService localeService;
  const _SwitchLangue({required this.localeService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeService,
      builder: (context, _) {
        final estFr = localeService.locale.languageCode == 'fr';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BoutonLanguage(
              label: 'FR',
              actif: estFr,
              onTap: () => localeService.changer('fr'),
            ),
            const SizedBox(width: 8),
            _BoutonLanguage(
              label: 'ع',
              actif: !estFr,
              onTap: () => localeService.changer('ar'),
            ),
          ],
        );
      },
    );
  }
}

class _BoutonLanguage extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback onTap;
  const _BoutonLanguage({
    required this.label,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: actif ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: actif ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: actif ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Row avec widget custom (pas de flèche) ────────────────────────
class _RowInfoAvecSwitch extends StatelessWidget {
  final Color couleur;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _RowInfoAvecSwitch({
    required this.couleur,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: couleur,
              borderRadius: BorderRadius.circular(10),
            ),
            child: PhosphorIcon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          // ← Le switch langue à droite
          child,
        ],
      ),
    );
  }
}
