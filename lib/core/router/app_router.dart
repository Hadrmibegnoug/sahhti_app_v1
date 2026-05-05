// core/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../auth/data/datasource/auth_datasource.dart';
import '../../auth/data/models/otp_verification_args.dart';
import '../../auth/data/models/register_pin_args.dart';
import '../../auth/data/models/registry_patient_model.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/screens/login_page.dart';
import '../../auth/presentation/screens/otp_verification_page.dart';
import '../../auth/presentation/screens/register_confirm_page.dart';
import '../../auth/presentation/screens/register_nni_page.dart';
import '../../auth/presentation/screens/register_pin_page.dart';
import '../../auth/presentation/screens/splash_page.dart';
import '../../passport_medical/presentation/screens/tabscreen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ── Guard : protéger toutes les routes sauf auth ────────────
    final session = Supabase.instance.client.auth.currentSession;
    final routesPubliques = [
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.registerNni,
      AppRoutes.registerConfirm,
      AppRoutes.registerPin,
      AppRoutes.otpVerification,
    ];

    // Si l'utilisateur n'est pas connecté et tente d'accéder
    // à une route protégée → rediriger vers login
    if (session == null && !routesPubliques.contains(settings.name)) {
      return _route(const LoginPage());
    }

    // Si l'utilisateur est connecté et tente d'aller sur login
    if (session != null && settings.name == AppRoutes.login) {
      return _route(const Tabscreen());
    }

    switch (settings.name) {
      // ── Auth ─────────────────────────────────────────────────
      case AppRoutes.splash:
        return _route(const SplashPage());

      case AppRoutes.login:
        return _route(const LoginPage());

      case AppRoutes.registerNni:
        return _route(const RegisterNniPage());

      case AppRoutes.registerConfirm:
        final args = settings.arguments as RegistryPatientModel;
        return _route(RegisterConfirmPage(patient: args));

      case AppRoutes.registerPin:
        final args = settings.arguments as RegisterPinArgs;
        return _route(
          BlocProvider(
            create: (_) => AuthBloc(AuthDatasource(Supabase.instance.client)),
            child: RegisterPinPage(args: args),
          ),
        );

      case AppRoutes.otpVerification:
        final args = settings.arguments as OtpVerificationArgs;
        return _route(
          BlocProvider(
            create: (_) => AuthBloc(AuthDatasource(Supabase.instance.client)),
            child: OtpVerificationPage(
              telephone: args.telephone,
              pin: args.pin,
              patient: args.patient,
            ),
          ),
        );

      // ── App principale (protégée) ─────────────────────────────
      case AppRoutes.home:
        return _route(const Tabscreen()); // ← Tabscreen ici

      default:
        return _route(const SplashPage());
    }
  }

  static MaterialPageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);

  static void goTo(BuildContext context, String route, {Object? args}) =>
      Navigator.of(context).pushNamed(route, arguments: args);

  static void goAndReplace(
    BuildContext context,
    String route, {
    Object? args,
  }) => Navigator.of(context).pushReplacementNamed(route, arguments: args);

  static void goAndClear(BuildContext context, String route, {Object? args}) =>
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(route, (r) => false, arguments: args);
}
