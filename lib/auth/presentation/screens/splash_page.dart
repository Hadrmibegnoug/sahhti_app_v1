// auth/presentation/screens/splash_page.dart — VERSION CORRIGÉE

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';

import 'package:sahha_pass/l10n/generated/app_localizations.dart';

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _verifierSession();
  }

  Future<void> _verifierSession() async {
    // Délai pour afficher le logo
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    // Simple : session existe → home, sinon → login
    // Pas de listener — chaque page gère sa propre navigation
    AppRouter.goAndClear(
      context,
      session != null ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text('🩺', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.appName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              t.appName,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
