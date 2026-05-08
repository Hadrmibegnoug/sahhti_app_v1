import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_alerts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../data/datasource/auth_datasource.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widget/champ_telephone.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthBloc(AuthDatasource(Supabase.instance.client))
            ..add(PinConnexionInitialise()),
      child: const _LoginView(),
    );
  }
}

// ← StatefulWidget UNIQUEMENT pour TextEditingController
class _LoginView extends StatefulWidget {
  const _LoginView();
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
                  label: 'tél',
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
                  keyboard: .text,
                  label: 'PIN',
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
                              "Se connecter",
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
                    child: const Text(
                      "Pas encore inscrit ? S'inscrire",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
