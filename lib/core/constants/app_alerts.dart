import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppAlerts {
  AppAlerts._();

  // ── SnackBar succès ───────────────────────────────────────────
  static void succes(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: _SnackContent(
            message: message,
            icon: Icons.check_circle,
            color: const Color(0xFF2E7D32),
            bg: const Color(0xFFE8F5E9),
          ),
        ),
      );
  }

  // ── SnackBar erreur ───────────────────────────────────────────
  static void erreur(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: _SnackContent(
            message: message,
            icon: Icons.error_outline,
            color: const Color(0xFFC62828),
            bg: const Color(0xFFFFEBEE),
          ),
        ),
      );
  }

  // ── SnackBar avertissement ────────────────────────────────────
  static void avertissement(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: _SnackContent(
            message: message,
            icon: Icons.warning_amber,
            color: const Color(0xFFE65100),
            bg: const Color(0xFFFFF8E1),
          ),
        ),
      );
  }

  // ── SnackBar connexion faible ─────────────────────────────────
  static void connexionFaible(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 5),
          content: _SnackContent(
            message: 'Connexion lente. Vérifiez votre réseau.',
            icon: Icons.wifi_off,
            color: const Color(0xFF37474F),
            bg: const Color(0xFFECEFF1),
          ),
        ),
      );
  }

  // ── Dialog confirmation ───────────────────────────────────────
  static Future<bool?> confirmation(
    BuildContext context, {
    required String titre,
    required String message,
    String labelConfirmer = 'Confirmer',
    String labelAnnuler = 'Annuler',
    bool dangereux = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(
          dangereux ? Icons.warning_amber : Icons.info_outline,
          color: dangereux ? AppColors.error : AppColors.primary,
          size: 40,
        ),
        title: Text(
          titre,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(labelAnnuler),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: dangereux ? AppColors.error : AppColors.primary,
            ),
            child: Text(
              labelConfirmer,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialog chargement ─────────────────────────────────────────
  static void chargement(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  static void fermerChargement(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

// ── Widget SnackBar personnalisé ──────────────────────────────────
class _SnackContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Color bg;
  const _SnackContent({
    required this.message,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
