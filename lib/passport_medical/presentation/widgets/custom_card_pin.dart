import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/build_context_l10n.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/home_bloc/home_event.dart';
import '../bloc/home_bloc/home_state.dart';

class CustomCardPin extends StatelessWidget {
  final HomeLoaded state;
  const CustomCardPin({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── En-tête ──────────────────────────────────────
            Row(
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  t.monQrCode,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // Badge sécurité
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield, size: 10, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Sécurisé',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── QR Code ─────────────────────────────────
                _QrCodeSection(qrData: state.patientModel.qrToken!),

                const SizedBox(width: 16),

                // ── PIN + Actions ───────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        t.qrCodeDescription,
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.6),
                          fontSize: 10,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Label PIN
                      Text(
                        t.codePIN,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Chiffres PIN
                      _PinChiffres(pin: state.pin, visible: state.piVisible),

                      const SizedBox(height: 10),

                      // Boutons Voir / Copier
                      Row(
                        children: [
                          _ActionBtn(
                            icon: state.piVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            label: state.piVisible ? t.masquer : t.voir,
                            onTap: () => context.read<HomeBloc>().add(
                              HomePinVisibiliyChange(),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _ActionBtn(
                            icon: Icons.copy,
                            label: state.pinCopy ? '${t.copier} ✓' : t.copier,
                            color: state.pinCopy ? Colors.green : null,
                            onTap: () =>
                                context.read<HomeBloc>().add(HomePinCopy()),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Avertissement
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            size: 10,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              t.nepasPartagerPIN,
                              style: TextStyle(
                                fontSize: 8.5,
                                color: AppColors.error.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section QR Code ───────────────────────────────────────────────
// Fonctionne hors-ligne : le QR est généré localement depuis le token
// Le token est chargé depuis Supabase une fois et stocké dans le state
class _QrCodeSection extends StatelessWidget {
  final String qrData;
  const _QrCodeSection({required this.qrData});

  @override
  Widget build(BuildContext context) {
    final hasToken = qrData.isNotEmpty && qrData != 'sahhti-patient-0';

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: hasToken ? Colors.white : AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: hasToken
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: QrImageView(
                data: qrData, // ← token UUID, pas de données médicales
                version: QrVersions.auto,
                size: 110,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.primary,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.primary,
                ),
              ),
            )
          : const Center(
              child: Icon(Icons.qr_code, color: AppColors.primary, size: 60),
            ),
    );
  }
}

// ── Chiffres PIN ──────────────────────────────────────────────────
class _PinChiffres extends StatelessWidget {
  final String pin;
  final bool visible;
  const _PinChiffres({required this.pin, required this.visible});

  @override
  Widget build(BuildContext context) {
    // Extraire les chiffres du PIN
    final chiffres = pin.length == 4 ? pin.split('') : List.filled(4, '●');

    return Row(
      children: List.generate(4, (i) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: visible
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: Center(
              child: visible
                  ? Text(
                      i < chiffres.length ? chiffres[i] : '?',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Bouton action compact ─────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: c.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: c),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: c,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
