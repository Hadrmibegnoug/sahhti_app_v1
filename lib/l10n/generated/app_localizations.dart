import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'Sahhti'**
  String get appName;

  /// No description provided for @accueil.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get accueil;

  /// No description provided for @medecins.
  ///
  /// In fr, this message translates to:
  /// **'Médecins'**
  String get medecins;

  /// No description provided for @messages.
  ///
  /// In fr, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @profil.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profil;

  /// No description provided for @rendezVous.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous'**
  String get rendezVous;

  /// No description provided for @dossierMedical.
  ///
  /// In fr, this message translates to:
  /// **'Dossier médical'**
  String get dossierMedical;

  /// No description provided for @ordonnances.
  ///
  /// In fr, this message translates to:
  /// **'Ordonnances'**
  String get ordonnances;

  /// No description provided for @vaccins.
  ///
  /// In fr, this message translates to:
  /// **'Vaccins'**
  String get vaccins;

  /// No description provided for @tel.
  ///
  /// In fr, this message translates to:
  /// **'tél'**
  String get tel;

  /// No description provided for @pin.
  ///
  /// In fr, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @connexion.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get connexion;

  /// No description provided for @inscription.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get inscription;

  /// No description provided for @seDeconnecter.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get seDeconnecter;

  /// No description provided for @annuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get annuler;

  /// No description provided for @confirmer.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirmer;

  /// No description provided for @retour.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get retour;

  /// No description provided for @reessayer.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get reessayer;

  /// No description provided for @sauvegarder.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get sauvegarder;

  /// No description provided for @fermer.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get fermer;

  /// No description provided for @suivant.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get suivant;

  /// No description provided for @valider.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get valider;

  /// No description provided for @votreTelephone.
  ///
  /// In fr, this message translates to:
  /// **'Votre téléphone'**
  String get votreTelephone;

  /// No description provided for @codePIN.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN'**
  String get codePIN;

  /// No description provided for @votrePIN.
  ///
  /// In fr, this message translates to:
  /// **'Votre code PIN'**
  String get votrePIN;

  /// No description provided for @confirmerPIN.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre code PIN'**
  String get confirmerPIN;

  /// No description provided for @choisirPIN.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre code PIN'**
  String get choisirPIN;

  /// No description provided for @ancienPIN.
  ///
  /// In fr, this message translates to:
  /// **'Ancien code PIN'**
  String get ancienPIN;

  /// No description provided for @nouveauPIN.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau code PIN'**
  String get nouveauPIN;

  /// No description provided for @changerPIN.
  ///
  /// In fr, this message translates to:
  /// **'Changer mon code PIN'**
  String get changerPIN;

  /// No description provided for @pinDifferents.
  ///
  /// In fr, this message translates to:
  /// **'Les codes ne correspondent pas. Recommencez.'**
  String get pinDifferents;

  /// No description provided for @pinObligatoire.
  ///
  /// In fr, this message translates to:
  /// **'4 chiffres — remplace votre mot de passe'**
  String get pinObligatoire;

  /// No description provided for @votreNNI.
  ///
  /// In fr, this message translates to:
  /// **'Votre NNI'**
  String get votreNNI;

  /// No description provided for @saisiNNI.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre Numéro National d\'Identité'**
  String get saisiNNI;

  /// No description provided for @nniIntrouvable.
  ///
  /// In fr, this message translates to:
  /// **'NNI introuvable. Vérifiez votre numéro.'**
  String get nniIntrouvable;

  /// No description provided for @verifierNNI.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier mon NNI'**
  String get verifierNNI;

  /// No description provided for @verificationSMS.
  ///
  /// In fr, this message translates to:
  /// **'Vérification SMS'**
  String get verificationSMS;

  /// No description provided for @codeSMSEnvoye.
  ///
  /// In fr, this message translates to:
  /// **'Un code à 6 chiffres a été envoyé au'**
  String get codeSMSEnvoye;

  /// No description provided for @renvoyerCode.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code'**
  String get renvoyerCode;

  /// No description provided for @verifierCode.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier le code'**
  String get verifierCode;

  /// No description provided for @codeRenvoye.
  ///
  /// In fr, this message translates to:
  /// **'Code renvoyé !'**
  String get codeRenvoye;

  /// No description provided for @codeRenvAvecSucces.
  ///
  /// In fr, this message translates to:
  /// **'Code renvoyé avec succès'**
  String get codeRenvAvecSucces;

  /// No description provided for @confirmezVosInformations.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer vos informations'**
  String get confirmezVosInformations;

  /// No description provided for @nni.
  ///
  /// In fr, this message translates to:
  /// **'NNI'**
  String get nni;

  /// No description provided for @dateDeNaissance.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get dateDeNaissance;

  /// No description provided for @nom.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get nom;

  /// No description provided for @numeroTel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get numeroTel;

  /// No description provided for @verifiezInformationsCorrespondent.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez que ces informations vous correspondent.'**
  String get verifiezInformationsCorrespondent;

  /// No description provided for @numInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Numéro invalide'**
  String get numInvalid;

  /// No description provided for @vosInfos.
  ///
  /// In fr, this message translates to:
  /// **'Vos informations'**
  String get vosInfos;

  /// No description provided for @sexe.
  ///
  /// In fr, this message translates to:
  /// **'Sexe'**
  String get sexe;

  /// No description provided for @masculin.
  ///
  /// In fr, this message translates to:
  /// **'Masculin'**
  String get masculin;

  /// No description provided for @feminin.
  ///
  /// In fr, this message translates to:
  /// **'Féminin'**
  String get feminin;

  /// No description provided for @continuer.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continuer;

  /// No description provided for @nniInvalide.
  ///
  /// In fr, this message translates to:
  /// **'NNI invalide'**
  String get nniInvalide;

  /// No description provided for @saisissezUnNouveauVotreCodePIN.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez à nouveau votre code PIN'**
  String get saisissezUnNouveauVotreCodePIN;

  /// No description provided for @chiffresCecodeRemplaceVotreMotDePasse.
  ///
  /// In fr, this message translates to:
  /// **'4 chiffres — ce code remplace votre mot de passe'**
  String get chiffresCecodeRemplaceVotreMotDePasse;

  /// No description provided for @aujourdhui.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get aujourdhui;

  /// No description provided for @hier.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get hier;

  /// No description provided for @ouvertureConversation.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture de la conversation...'**
  String get ouvertureConversation;

  /// No description provided for @commencerLaConversation.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la conversation'**
  String get commencerLaConversation;

  /// No description provided for @passport.
  ///
  /// In fr, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @dossier.
  ///
  /// In fr, this message translates to:
  /// **'Dossier'**
  String get dossier;

  /// No description provided for @prescriptions.
  ///
  /// In fr, this message translates to:
  /// **'Prescriptions'**
  String get prescriptions;

  /// No description provided for @bilanSanguin.
  ///
  /// In fr, this message translates to:
  /// **'Bilan sanguin'**
  String get bilanSanguin;

  /// No description provided for @examensImageries.
  ///
  /// In fr, this message translates to:
  /// **'Examens & imageries'**
  String get examensImageries;

  /// No description provided for @ajouter.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get ajouter;

  /// No description provided for @echographieAbdominale.
  ///
  /// In fr, this message translates to:
  /// **'Échographie abdominale'**
  String get echographieAbdominale;

  /// No description provided for @radiographieThorax.
  ///
  /// In fr, this message translates to:
  /// **'Radiographie du thorax'**
  String get radiographieThorax;

  /// No description provided for @irmCelebrale.
  ///
  /// In fr, this message translates to:
  /// **'IRM cérébrale'**
  String get irmCelebrale;

  /// No description provided for @telechargerPDF.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger PDF'**
  String get telechargerPDF;

  /// No description provided for @partager.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get partager;

  /// No description provided for @medeclinTraitant.
  ///
  /// In fr, this message translates to:
  /// **'Médecin traitant'**
  String get medeclinTraitant;

  /// No description provided for @contactUrgence.
  ///
  /// In fr, this message translates to:
  /// **'Contact d\'urgence'**
  String get contactUrgence;

  /// No description provided for @changerMonPin.
  ///
  /// In fr, this message translates to:
  /// **'Changer mon PIN'**
  String get changerMonPin;

  /// No description provided for @reinitialiseViaAncienPIN.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser via ancien PIN'**
  String get reinitialiseViaAncienPIN;

  /// No description provided for @etape.
  ///
  /// In fr, this message translates to:
  /// **'Étape {numero}/3'**
  String etape(int numero);

  /// No description provided for @bonjour.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {prenom} 👋'**
  String bonjour(String prenom);

  /// No description provided for @pasEncoreInscrit.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore inscrit ? S\'inscrire'**
  String get pasEncoreInscrit;

  /// No description provided for @dejaInscrit.
  ///
  /// In fr, this message translates to:
  /// **'Déjà inscrit ? Se connecter'**
  String get dejaInscrit;

  /// No description provided for @monQrCode.
  ///
  /// In fr, this message translates to:
  /// **'Mon QR Code & PIN'**
  String get monQrCode;

  /// No description provided for @qrCodeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Présentez ce QR code et votre PIN à votre médecin pour autoriser l\'accès à votre dossier.'**
  String get qrCodeDescription;

  /// No description provided for @masquer.
  ///
  /// In fr, this message translates to:
  /// **'Masquer'**
  String get masquer;

  /// No description provided for @voir.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get voir;

  /// No description provided for @copier.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copier;

  /// No description provided for @copie.
  ///
  /// In fr, this message translates to:
  /// **'Copié ✓'**
  String get copie;

  /// No description provided for @nepasPartagerPIN.
  ///
  /// In fr, this message translates to:
  /// **'Ne partagez votre PIN qu\'en consultation'**
  String get nepasPartagerPIN;

  /// No description provided for @groupeSanguin.
  ///
  /// In fr, this message translates to:
  /// **'Groupe sanguin'**
  String get groupeSanguin;

  /// No description provided for @allergies.
  ///
  /// In fr, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @antecedents.
  ///
  /// In fr, this message translates to:
  /// **'Antécédents'**
  String get antecedents;

  /// No description provided for @aucuneAllergie.
  ///
  /// In fr, this message translates to:
  /// **'Aucune allergie'**
  String get aucuneAllergie;

  /// No description provided for @donneesPersonnelles.
  ///
  /// In fr, this message translates to:
  /// **'Données Personnelles'**
  String get donneesPersonnelles;

  /// No description provided for @donneesMedicales.
  ///
  /// In fr, this message translates to:
  /// **'Données médicales de base'**
  String get donneesMedicales;

  /// No description provided for @historiqueAcces.
  ///
  /// In fr, this message translates to:
  /// **'Historique d\'accès'**
  String get historiqueAcces;

  /// No description provided for @quiAConsulte.
  ///
  /// In fr, this message translates to:
  /// **'Qui a consulté mon dossier'**
  String get quiAConsulte;

  /// No description provided for @specialites.
  ///
  /// In fr, this message translates to:
  /// **'Spécialités'**
  String get specialites;

  /// No description provided for @suivisIndicateurs.
  ///
  /// In fr, this message translates to:
  /// **'Suivi des indicateurs'**
  String get suivisIndicateurs;

  /// No description provided for @poidsActuel.
  ///
  /// In fr, this message translates to:
  /// **'Poids Actuel'**
  String get poidsActuel;

  /// No description provided for @carnetVaccination.
  ///
  /// In fr, this message translates to:
  /// **'Carnet de vaccination'**
  String get carnetVaccination;

  /// No description provided for @complet.
  ///
  /// In fr, this message translates to:
  /// **'Complet'**
  String get complet;

  /// No description provided for @rappel.
  ///
  /// In fr, this message translates to:
  /// **'Rappel'**
  String get rappel;

  /// No description provided for @saisirVotreNni.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre Numéro National d\'Identité \n pour récupérer vos informations.'**
  String get saisirVotreNni;

  /// No description provided for @cardiologue.
  ///
  /// In fr, this message translates to:
  /// **'cardiologue'**
  String get cardiologue;

  /// No description provided for @pediatre.
  ///
  /// In fr, this message translates to:
  /// **'pédiatre'**
  String get pediatre;

  /// No description provided for @ophtalmologue.
  ///
  /// In fr, this message translates to:
  /// **'ophtalmologue'**
  String get ophtalmologue;

  /// No description provided for @neprologue.
  ///
  /// In fr, this message translates to:
  /// **'neprologue'**
  String get neprologue;

  /// No description provided for @aucunIndicateurEnregistre.
  ///
  /// In fr, this message translates to:
  /// **'Aucun indicateur enregistré'**
  String get aucunIndicateurEnregistre;

  /// No description provided for @heartRate.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence cardiaque'**
  String get heartRate;

  /// No description provided for @bloodPressure.
  ///
  /// In fr, this message translates to:
  /// **'Tension artérielle'**
  String get bloodPressure;

  /// No description provided for @temperature.
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get temperature;

  /// No description provided for @weight.
  ///
  /// In fr, this message translates to:
  /// **'Poids'**
  String get weight;

  /// No description provided for @oxygenSaturation.
  ///
  /// In fr, this message translates to:
  /// **'Saturation O₂'**
  String get oxygenSaturation;

  /// No description provided for @dose.
  ///
  /// In fr, this message translates to:
  /// **'{recu}/{total} dose(s)'**
  String dose(int recu, int total);

  /// No description provided for @chercherMedecin.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un médecin...'**
  String get chercherMedecin;

  /// No description provided for @tous.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get tous;

  /// No description provided for @aucunMedecinTrouve.
  ///
  /// In fr, this message translates to:
  /// **'Aucun médecin trouvé'**
  String get aucunMedecinTrouve;

  /// No description provided for @prendreRDV.
  ///
  /// In fr, this message translates to:
  /// **'Prendre RDV'**
  String get prendreRDV;

  /// No description provided for @aPropos.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aPropos;

  /// No description provided for @disponibilites.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilités'**
  String get disponibilites;

  /// No description provided for @aucuneDisponibilite.
  ///
  /// In fr, this message translates to:
  /// **'Aucune disponibilité enregistrée.'**
  String get aucuneDisponibilite;

  /// No description provided for @typeConsultation.
  ///
  /// In fr, this message translates to:
  /// **'Type de consultation'**
  String get typeConsultation;

  /// No description provided for @presentiel.
  ///
  /// In fr, this message translates to:
  /// **'Présentiel'**
  String get presentiel;

  /// No description provided for @teleconsultation.
  ///
  /// In fr, this message translates to:
  /// **'Téléconsultation'**
  String get teleconsultation;

  /// No description provided for @dateRendezVous.
  ///
  /// In fr, this message translates to:
  /// **'Date du rendez-vous'**
  String get dateRendezVous;

  /// No description provided for @selectionnerDate.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date'**
  String get selectionnerDate;

  /// No description provided for @motifConsultation.
  ///
  /// In fr, this message translates to:
  /// **'Motif de consultation'**
  String get motifConsultation;

  /// No description provided for @motifHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez brièvement votre motif...'**
  String get motifHint;

  /// No description provided for @confirmerRDV.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le rendez-vous'**
  String get confirmerRDV;

  /// No description provided for @selectionnerDisponibilite.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une disponibilité.'**
  String get selectionnerDisponibilite;

  /// No description provided for @rdvConfirme.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous confirmé avec {nom} ✓'**
  String rdvConfirme(String nom);

  /// No description provided for @aucuneConversation.
  ///
  /// In fr, this message translates to:
  /// **'Aucune conversation'**
  String get aucuneConversation;

  /// No description provided for @contactezMedecin.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur + pour contacter un médecin'**
  String get contactezMedecin;

  /// No description provided for @contacterMedecin.
  ///
  /// In fr, this message translates to:
  /// **'Contacter un médecin'**
  String get contacterMedecin;

  /// No description provided for @votreMMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre message...'**
  String get votreMMessage;

  /// No description provided for @nouveau.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get nouveau;

  /// No description provided for @monProfil.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get monProfil;

  /// No description provided for @informationsPersonnelles.
  ///
  /// In fr, this message translates to:
  /// **'INFORMATIONS PERSONNELLES'**
  String get informationsPersonnelles;

  /// No description provided for @preferences.
  ///
  /// In fr, this message translates to:
  /// **'PRÉFÉRENCES'**
  String get preferences;

  /// No description provided for @securiteDonnees.
  ///
  /// In fr, this message translates to:
  /// **'SÉCURITÉ & DONNÉES'**
  String get securiteDonnees;

  /// No description provided for @langue.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get langue;

  /// No description provided for @langueSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Français / العربية'**
  String get langueSubtitle;

  /// No description provided for @rappelsRDV.
  ///
  /// In fr, this message translates to:
  /// **'Rappels RDV'**
  String get rappelsRDV;

  /// No description provided for @rappelsRDVSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Push + SMS · J-1 et H-2'**
  String get rappelsRDVSubtitle;

  /// No description provided for @rappelsMedicaments.
  ///
  /// In fr, this message translates to:
  /// **'Rappels médicaments'**
  String get rappelsMedicaments;

  /// No description provided for @rappelsMedicamentsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Traitements en cours'**
  String get rappelsMedicamentsSubtitle;

  /// No description provided for @biometrie.
  ///
  /// In fr, this message translates to:
  /// **'Biométrie'**
  String get biometrie;

  /// No description provided for @biometrieSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Face ID / Empreinte digitale'**
  String get biometrieSubtitle;

  /// No description provided for @confirmationDeconnexion.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get confirmationDeconnexion;

  /// No description provided for @version.
  ///
  /// In fr, this message translates to:
  /// **'Sahhti v1.0.0 · صحتي'**
  String get version;

  /// No description provided for @erreurConnexion.
  ///
  /// In fr, this message translates to:
  /// **'Numéro ou code PIN incorrect.'**
  String get erreurConnexion;

  /// No description provided for @erreurReseau.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre connexion.'**
  String get erreurReseau;

  /// No description provided for @erreurGenerale.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessayez.'**
  String get erreurGenerale;

  /// No description provided for @connexionFaible.
  ///
  /// In fr, this message translates to:
  /// **'Connexion lente. Vérifiez votre réseau.'**
  String get connexionFaible;

  /// No description provided for @profilIntrouvable.
  ///
  /// In fr, this message translates to:
  /// **'Profil patient introuvable.'**
  String get profilIntrouvable;

  /// No description provided for @aucunMessageEnvPremier.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message. Commencez une nouvelle conversation !'**
  String get aucunMessageEnvPremier;

  /// No description provided for @rdv.
  ///
  /// In fr, this message translates to:
  /// **'RDV'**
  String get rdv;

  /// No description provided for @chat.
  ///
  /// In fr, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @prochainsRdv.
  ///
  /// In fr, this message translates to:
  /// **'Prochains Rendez-vous'**
  String get prochainsRdv;

  /// No description provided for @voirTout.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get voirTout;

  /// No description provided for @aucunRdvTrouve.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous trouvé'**
  String get aucunRdvTrouve;

  /// No description provided for @confirme.
  ///
  /// In fr, this message translates to:
  /// **'confirmed'**
  String get confirme;

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'pending'**
  String get pending;

  /// No description provided for @cancelled.
  ///
  /// In fr, this message translates to:
  /// **'cancelled'**
  String get cancelled;

  /// No description provided for @aucunVaccinEnreg.
  ///
  /// In fr, this message translates to:
  /// **'Aucun vaccin enregistré'**
  String get aucunVaccinEnreg;

  /// No description provided for @medGeneraliste.
  ///
  /// In fr, this message translates to:
  /// **'Médecin Généraliste'**
  String get medGeneraliste;

  /// No description provided for @gynecologue.
  ///
  /// In fr, this message translates to:
  /// **'Gynécologue'**
  String get gynecologue;

  /// No description provided for @dermatologue.
  ///
  /// In fr, this message translates to:
  /// **'Dermatologue'**
  String get dermatologue;

  /// No description provided for @aucuneConsultation.
  ///
  /// In fr, this message translates to:
  /// **'Aucune consultation enregistrée'**
  String get aucuneConsultation;

  /// No description provided for @aucunRdvEn.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous en {specialite}'**
  String aucunRdvEn(String specialite);

  /// No description provided for @at.
  ///
  /// In fr, this message translates to:
  /// **'à'**
  String get at;

  /// No description provided for @momMedecin.
  ///
  /// In fr, this message translates to:
  /// **'Mon médecin'**
  String get momMedecin;

  /// No description provided for @rdvConfirmeAvec.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous confirmé avec'**
  String get rdvConfirmeAvec;

  /// No description provided for @choisirUneDisponibilite.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une disponibilité.'**
  String get choisirUneDisponibilite;

  /// No description provided for @profilMisAJour.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour'**
  String get profilMisAJour;

  /// No description provided for @codePinChangeAvecSucces.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN changé avec succès'**
  String get codePinChangeAvecSucces;

  /// No description provided for @mru.
  ///
  /// In fr, this message translates to:
  /// **'{montant} MRU'**
  String mru(int montant);

  /// No description provided for @note.
  ///
  /// In fr, this message translates to:
  /// **'{valeur} ⭐'**
  String note(String valeur);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
