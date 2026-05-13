class AppRoutes {
  AppRoutes._();

  // ── Auth ──────────────────────────────────────────────────────
  static const String splash = '/';
  static const String login = '/login';
  static const String registerNni = '/register/nni';
  static const String registerConfirm = '/register/confirm';
  static const String registerPin = '/register/pin';

  // ── App principale ────────────────────────────────────────────
  static const String home = '/home';
  static const String dossier = '/home/dossier';
  //static const String rdvDossier        = '/home/dossier/rdvDossier';
  static const String passport = '/home/passport';
  static const String ordonnances = '/home/ordonnances';
  static const String medecins = '/medecins';
  static const String rdvMedecin = '/medecins/rdvMedecin';
  static const String conversations = '/messages';
  static const String chat = '/messages/chat';
  static const String specialiteDetail = '/dossier/specialite';
  // core/router/app_routes.dart — ajouter
  static const String otpVerification = '/register/otp';
  static const String profil = '/profil';

}
