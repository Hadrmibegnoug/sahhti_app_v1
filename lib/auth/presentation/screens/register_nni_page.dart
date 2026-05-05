import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:sahha_pass/core/constants/app_colors.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../data/datasource/auth_datasource.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterNniPage extends StatelessWidget {
  const RegisterNniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthDatasource(Supabase.instance.client)),
      child: const _RegisterNniView(),
    );
  }
}

class _RegisterNniView extends StatefulWidget {
  const _RegisterNniView();

  @override
  State<_RegisterNniView> createState() => _RegisterNniViewState();
}

class _RegisterNniViewState extends State<_RegisterNniView> {
  final _nniCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nniCtrl.dispose();
    super.dispose();
  }

  void _verifier() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(NniSaisi(_nniCtrl.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is NniTrouve) {
          // Passer les données du registre à la page suivante
          AppRouter.goTo(ctx, AppRoutes.registerConfirm, args: state.patient);
        }
        if (state is AuthErreur) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'Inscription',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Étape 1/3',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Votre NNI',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Saisissez votre Numéro National d\'Identité '
                  'pour récupérer vos informations.',
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _nniCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Numéro NNI',
                    prefixIcon: Icon(Icons.badge_outlined),
                    hintText: 'Ex: 1234567890',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 5) {
                      return 'NNI invalide';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state is AuthChargement ? null : _verifier,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: state is AuthChargement
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              'Vérifier mon NNI',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
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
