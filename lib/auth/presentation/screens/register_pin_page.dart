// auth/presentation/screens/register_pin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_alerts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../data/datasource/auth_datasource.dart';
import '../../data/models/otp_verification_args.dart';
import '../../data/models/register_pin_args.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widget/clavier_pin.dart';

class RegisterPinPage extends StatelessWidget {
  final RegisterPinArgs args;
  const RegisterPinPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(AuthDatasource(Supabase.instance.client))
            ..add(PinInscriptionInitialise()),
      child: _RegisterPinView(args: args),
    );
  }
}

// ← StatelessWidget — plus rien à gérer localement
class _RegisterPinView extends StatelessWidget {
  final RegisterPinArgs args;
  const _RegisterPinView({required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        // SMS envoyé → page OTP
        if (state is OtpEnvoye) {
          AppRouter.goTo(
            ctx,
            AppRoutes.otpVerification,
            args: OtpVerificationArgs(
              telephone: state.telephone,
              pin: state.pin,
              patient: state.patient,
            ),
          );
        }

        // PIN 2 complet → vérifier correspondance
        if (state is PinSaisieState &&
            state.etapeConfirmation &&
            state.pinConfirmation.length == 4) {
          if (!state.correspondent) {
            // Les PIN ne correspondent pas → réinitialiser
            AppAlerts.erreur(context, 'Les codes ne correspondent pas.');
            ctx.read<AuthBloc>().add(PinInscriptionInitialise());
            return;
          }
          // Correspondance OK → déclencher l'inscription
          ctx.read<AuthBloc>().add(
            InscriptionDemandee(
              patient: args.patient,
              telephone: args.telephone,
              pin: state.pin.join(),
            ),
          );
        }

        if (state is AuthErreur) {
          AppAlerts.erreur(ctx, state.message);
          ctx.read<AuthBloc>().add(PinInscriptionInitialise());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final pinState = state is PinSaisieState
              ? state
              : const PinSaisieState();
          final current = pinState.current;

          return Scaffold(
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
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Étape 3/3',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),

                  // Titre change selon l'étape
                  Text(
                    pinState.etapeConfirmation
                        ? 'Confirmez votre code PIN'
                        : 'Choisissez votre code PIN',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pinState.etapeConfirmation
                        ? 'Saisissez à nouveau votre code PIN'
                        : '4 chiffres — ce code remplace votre mot de passe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Indicateurs PIN — viennent du BLoC
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < current.length
                              ? Colors.white
                              : Colors.white.withOpacity(0.25),
                        ),
                      );
                    }),
                  ),

                  const Spacer(),

                  // Clavier — envoie events au BLoC
                  ClavierPin(
                    onDigit: (d) =>
                        context.read<AuthBloc>().add(PinChiffreAjoute(d)),
                    onDelete: () =>
                        context.read<AuthBloc>().add(PinChiffreSupprime()),
                    loading: state is AuthChargement,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
