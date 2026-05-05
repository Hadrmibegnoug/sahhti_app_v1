// presentation/screens/auth/register_confirm_page.dart

import 'package:flutter/material.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../data/models/register_pin_args.dart';
import '../../data/models/registry_patient_model.dart';

class RegisterConfirmPage extends StatefulWidget {
  final RegistryPatientModel patient;
  const RegisterConfirmPage({super.key, required this.patient});

  @override
  State<RegisterConfirmPage> createState() => _RegisterConfirmPageState();
}

class _RegisterConfirmPageState extends State<RegisterConfirmPage> {
  final _phoneCtrl = TextEditingController();
  final _formKey   = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _continuer() {
    if (!_formKey.currentState!.validate()) return;
    AppRouter.goTo(
      context,
      AppRoutes.registerPin,
      args: RegisterPinArgs(
        patient:   widget.patient,
        telephone: _phoneCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Confirmer vos informations',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Étape 2/3',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Vos informations',
                  style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Vérifiez que ces informations vous correspondent.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // ── Carte infos patient ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Text(
                        '${widget.patient.firstName[0]}'
                        '${widget.patient.lastName[0]}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.patient.nomComplet,
                      style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    _InfoRow(label: 'NNI',
                        valeur: widget.patient.nni),
                    if (widget.patient.dateOfBirth != null)
                      _InfoRow(
                          label:  'Date de naissance',
                          valeur: widget.patient.dateOfBirth!),
                    if (widget.patient.gender != null)
                      _InfoRow(
                          label:  'Sexe',
                          valeur: widget.patient.gender == 'M'
                              ? 'Masculin'
                              : 'Féminin'),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Numéro de téléphone ──────────────────────
              const Text('Numéro de téléphone',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+222 XX XX XX XX',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) {
                  if (v == null || v.trim().length < 8) {
                    return 'Numéro invalide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continuer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Continuer',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, valeur;
  const _InfoRow({required this.label, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(valeur,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}