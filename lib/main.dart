import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/services/locale_service.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ymmdyaqjuallibixpeil.supabase.co',
    anonKey: 'sb_publishable_MMhux97CTu6TO5VQbVkdeg_CDAr6Xzw',
  );
  final localeService = LocaleService();
  await localeService.charger();
  AppRouter.localeService = localeService;
  runApp(SahhtiApp(localeService: localeService));
}

class SahhtiApp extends StatelessWidget {
  final LocaleService localeService;
  const SahhtiApp({super.key, required this.localeService});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder reconstruit uniquement quand la langue change
    return ListenableBuilder(
      listenable: localeService,
      builder: (context, _) {
        return MaterialApp(
          title: 'Sahhti صحتي',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,

          // ── Locale réactive ──────────────────────────────────
          locale: localeService.locale,
          supportedLocales: const [Locale('fr'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Gestion du sens du texte (RTL pour l'arabe)
          builder: (context, child) {
            return Directionality(
              textDirection: localeService.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },

          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
