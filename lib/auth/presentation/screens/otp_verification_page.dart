import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_alerts.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../data/models/registry_patient_model.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:sahha_pass/l10n/generated/app_localizations.dart';

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class OtpVerificationPage extends StatefulWidget {
  final String telephone;
  final String pin;
  final RegistryPatientModel patient;

  const OtpVerificationPage({
    super.key,
    required this.telephone,
    required this.pin,
    required this.patient,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // 6 contrôleurs pour les 6 chiffres du code SMS
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _renvoyeOk = false;

  @override
  void initState() {
    super.initState();
    // Focus automatique sur le premier champ
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNodes[0].requestFocus(),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // Gérer la saisie chiffre par chiffre
  void _onChanged(String val, int index) {
    // Coller plusieurs chiffres d'un coup (ex: depuis SMS)
    if (val.length > 1) {
      final digits = val.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      if (digits.length >= 6) {
        _focusNodes[5].requestFocus();
        _verifier();
      }
      return;
    }

    if (val.isEmpty) {
      // Retour en arrière
      if (index > 0) _focusNodes[index - 1].requestFocus();
      return;
    }

    // Avancer au champ suivant
    if (index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Si les 6 chiffres sont remplis → vérifier automatiquement
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) _verifier();
  }

  void _verifier() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) return;

    context.read<AuthBloc>().add(
      OtpInscriptionVerifie(
        telephone: widget.telephone,
        otpCode: code,
        pin: widget.pin,
        patient: widget.patient,
      ),
    );
  }

  void _renvoyer() {
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    setState(() => _renvoyeOk = false);
    context.read<AuthBloc>().add(OtpRenvoye(widget.telephone));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthConnecte) {
          AppRouter.goAndClear(ctx, AppRoutes.home);
        }
        if (state is OtpRenvoyeChargement) {
          setState(() => _renvoyeOk = true);
          AppAlerts.succes(ctx, t.codeRenvAvecSucces);
        }
        if (state is AuthErreur) {
          // Vider les champs et afficher l'erreur
          for (final c in _controllers) c.clear();
          _focusNodes[0].requestFocus();
          AppAlerts.erreur(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── En-tête ─────────────────────────────────
                Text(
                  t.verificationSMS,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${t.codeSMSEnvoye}\n'
                  '${widget.telephone}',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),

                const SizedBox(height: 40),

                // ── 6 cases OTP ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return SizedBox(
                      width: 56,
                      height: 56,
                      child: TextFormField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6, // permet le collage
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (v) => _onChanged(v, i),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // ── Bouton Vérifier ──────────────────────────
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    final loading = state is AuthChargement;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : _verifier,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              )
                            : Text(
                                t.verifierCode,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Renvoyer le code ─────────────────────────
                Center(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (ctx, state) {
                      final loading = state is OtpRenvoyeChargement;
                      return TextButton(
                        onPressed: loading ? null : _renvoyer,
                        child: loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white70,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                t.renvoyerCode,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
