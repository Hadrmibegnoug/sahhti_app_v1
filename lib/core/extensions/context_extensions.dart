import 'package:flutter/material.dart';
import 'package:sahha_pass/l10n/generated/app_localizations.dart';

extension ContextExtensions on BuildContext {
  // Traduction — usage : context.t.accueil
  AppLocalizations get t => AppLocalizations.of(this);

  // Taille écran
  double get hauteur => MediaQuery.of(this).size.height;
  double get largeur  => MediaQuery.of(this).size.width;

  // Thème
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
}