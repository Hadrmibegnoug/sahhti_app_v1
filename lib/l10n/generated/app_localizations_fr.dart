// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Sahhti';

  @override
  String get accueil => 'Accueil';

  @override
  String get medecins => 'Médecins';

  @override
  String get messages => 'Messages';

  @override
  String get profil => 'Profil';

  @override
  String get rendezVous => 'Rendez-vous';

  @override
  String get dossierMedical => 'Dossier médical';

  @override
  String get ordonnances => 'Ordonnances';

  @override
  String get vaccins => 'Vaccins';

  @override
  String get tel => 'tél';

  @override
  String get pin => 'PIN';

  @override
  String get connexion => 'Connexion';

  @override
  String get inscription => 'Inscription';

  @override
  String get seDeconnecter => 'Se déconnecter';

  @override
  String get annuler => 'Annuler';

  @override
  String get confirmer => 'Confirmer';

  @override
  String get retour => 'Retour';

  @override
  String get reessayer => 'Réessayer';

  @override
  String get sauvegarder => 'Sauvegarder';

  @override
  String get fermer => 'Fermer';

  @override
  String get suivant => 'Suivant';

  @override
  String get valider => 'Valider';

  @override
  String get votreTelephone => 'Votre téléphone';

  @override
  String get codePIN => 'Code PIN';

  @override
  String get votrePIN => 'Votre code PIN';

  @override
  String get confirmerPIN => 'Confirmez votre code PIN';

  @override
  String get choisirPIN => 'Choisissez votre code PIN';

  @override
  String get ancienPIN => 'Ancien code PIN';

  @override
  String get nouveauPIN => 'Nouveau code PIN';

  @override
  String get changerPIN => 'Changer mon code PIN';

  @override
  String get pinDifferents => 'Les codes ne correspondent pas. Recommencez.';

  @override
  String get pinObligatoire => '4 chiffres — remplace votre mot de passe';

  @override
  String get votreNNI => 'Votre NNI';

  @override
  String get saisiNNI => 'Saisissez votre Numéro National d\'Identité';

  @override
  String get nniIntrouvable => 'NNI introuvable. Vérifiez votre numéro.';

  @override
  String get verifierNNI => 'Vérifier mon NNI';

  @override
  String get verificationSMS => 'Vérification SMS';

  @override
  String get codeSMSEnvoye => 'Un code à 6 chiffres a été envoyé au';

  @override
  String get renvoyerCode => 'Renvoyer le code';

  @override
  String get verifierCode => 'Vérifier le code';

  @override
  String get codeRenvoye => 'Code renvoyé !';

  @override
  String get codeRenvAvecSucces => 'Code renvoyé avec succès';

  @override
  String get confirmezVosInformations => 'Confirmer vos informations';

  @override
  String get nni => 'NNI';

  @override
  String get dateDeNaissance => 'Date de naissance';

  @override
  String get nom => 'Nom';

  @override
  String get numeroTel => 'Numéro de téléphone';

  @override
  String get verifiezInformationsCorrespondent =>
      'Vérifiez que ces informations vous correspondent.';

  @override
  String get numInvalid => 'Numéro invalide';

  @override
  String get vosInfos => 'Vos informations';

  @override
  String get sexe => 'Sexe';

  @override
  String get masculin => 'Masculin';

  @override
  String get feminin => 'Féminin';

  @override
  String get continuer => 'Continuer';

  @override
  String get nniInvalide => 'NNI invalide';

  @override
  String get saisissezUnNouveauVotreCodePIN =>
      'Saisissez à nouveau votre code PIN';

  @override
  String get chiffresCecodeRemplaceVotreMotDePasse =>
      '4 chiffres — ce code remplace votre mot de passe';

  @override
  String get aujourdhui => 'Aujourd\'hui';

  @override
  String get hier => 'Hier';

  @override
  String get ouvertureConversation => 'Ouverture de la conversation...';

  @override
  String get commencerLaConversation => 'Commencer la conversation';

  @override
  String get passport => 'Passport';

  @override
  String get dossier => 'Dossier';

  @override
  String get prescriptions => 'Prescriptions';

  @override
  String get bilanSanguin => 'Bilan sanguin';

  @override
  String get examensImageries => 'Examens & imageries';

  @override
  String get ajouter => 'Ajouter';

  @override
  String get echographieAbdominale => 'Échographie abdominale';

  @override
  String get radiographieThorax => 'Radiographie du thorax';

  @override
  String get irmCelebrale => 'IRM cérébrale';

  @override
  String get telechargerPDF => 'Télécharger PDF';

  @override
  String get partager => 'Partager';

  @override
  String get medeclinTraitant => 'Médecin traitant';

  @override
  String get contactUrgence => 'Contact d\'urgence';

  @override
  String get changerMonPin => 'Changer mon PIN';

  @override
  String get reinitialiseViaAncienPIN => 'Réinitialiser via ancien PIN';

  @override
  String etape(int numero) {
    return 'Étape $numero/3';
  }

  @override
  String bonjour(String prenom) {
    return 'Bonjour $prenom 👋';
  }

  @override
  String get pasEncoreInscrit => 'Pas encore inscrit ? S\'inscrire';

  @override
  String get dejaInscrit => 'Déjà inscrit ? Se connecter';

  @override
  String get monQrCode => 'Mon QR Code & PIN';

  @override
  String get qrCodeDescription =>
      'Présentez ce QR code et votre PIN à votre médecin pour autoriser l\'accès à votre dossier.';

  @override
  String get masquer => 'Masquer';

  @override
  String get voir => 'Voir';

  @override
  String get copier => 'Copier';

  @override
  String get copie => 'Copié ✓';

  @override
  String get nepasPartagerPIN => 'Ne partagez votre PIN qu\'en consultation';

  @override
  String get groupeSanguin => 'Groupe sanguin';

  @override
  String get allergies => 'Allergies';

  @override
  String get antecedents => 'Antécédents';

  @override
  String get aucuneAllergie => 'Aucune allergie';

  @override
  String get donneesPersonnelles => 'Données Personnelles';

  @override
  String get donneesMedicales => 'Données médicales de base';

  @override
  String get historiqueAcces => 'Historique d\'accès';

  @override
  String get quiAConsulte => 'Qui a consulté mon dossier';

  @override
  String get specialites => 'Spécialités';

  @override
  String get suivisIndicateurs => 'Suivi des indicateurs';

  @override
  String get poidsActuel => 'Poids Actuel';

  @override
  String get carnetVaccination => 'Carnet de vaccination';

  @override
  String get complet => 'Complet';

  @override
  String get rappel => 'Rappel';

  @override
  String get saisirVotreNni =>
      'Saisissez votre Numéro National d\'Identité \n pour récupérer vos informations.';

  @override
  String get cardiologue => 'cardiologue';

  @override
  String get pediatre => 'pédiatre';

  @override
  String get ophtalmologue => 'ophtalmologue';

  @override
  String get neprologue => 'neprologue';

  @override
  String get aucunIndicateurEnregistre => 'Aucun indicateur enregistré';

  @override
  String get heartRate => 'Fréquence cardiaque';

  @override
  String get bloodPressure => 'Tension artérielle';

  @override
  String get temperature => 'Température';

  @override
  String get weight => 'Poids';

  @override
  String get oxygenSaturation => 'Saturation O₂';

  @override
  String dose(int recu, int total) {
    return '$recu/$total dose(s)';
  }

  @override
  String get chercherMedecin => 'Rechercher un médecin...';

  @override
  String get tous => 'Tous';

  @override
  String get aucunMedecinTrouve => 'Aucun médecin trouvé';

  @override
  String get prendreRDV => 'Prendre RDV';

  @override
  String get aPropos => 'À propos';

  @override
  String get disponibilites => 'Disponibilités';

  @override
  String get aucuneDisponibilite => 'Aucune disponibilité enregistrée.';

  @override
  String get typeConsultation => 'Type de consultation';

  @override
  String get presentiel => 'Présentiel';

  @override
  String get teleconsultation => 'Téléconsultation';

  @override
  String get dateRendezVous => 'Date du rendez-vous';

  @override
  String get selectionnerDate => 'Sélectionner une date';

  @override
  String get motifConsultation => 'Motif de consultation';

  @override
  String get motifHint => 'Décrivez brièvement votre motif...';

  @override
  String get confirmerRDV => 'Confirmer le rendez-vous';

  @override
  String get selectionnerDisponibilite =>
      'Veuillez sélectionner une disponibilité.';

  @override
  String rdvConfirme(String nom) {
    return 'Rendez-vous confirmé avec $nom ✓';
  }

  @override
  String get aucuneConversation => 'Aucune conversation';

  @override
  String get contactezMedecin => 'Appuyez sur + pour contacter un médecin';

  @override
  String get contacterMedecin => 'Contacter un médecin';

  @override
  String get votreMMessage => 'Votre message...';

  @override
  String get nouveau => 'Nouveau';

  @override
  String get monProfil => 'Mon Profil';

  @override
  String get informationsPersonnelles => 'INFORMATIONS PERSONNELLES';

  @override
  String get preferences => 'PRÉFÉRENCES';

  @override
  String get securiteDonnees => 'SÉCURITÉ & DONNÉES';

  @override
  String get langue => 'Langue';

  @override
  String get langueSubtitle => 'Français / العربية';

  @override
  String get rappelsRDV => 'Rappels RDV';

  @override
  String get rappelsRDVSubtitle => 'Push + SMS · J-1 et H-2';

  @override
  String get rappelsMedicaments => 'Rappels médicaments';

  @override
  String get rappelsMedicamentsSubtitle => 'Traitements en cours';

  @override
  String get biometrie => 'Biométrie';

  @override
  String get biometrieSubtitle => 'Face ID / Empreinte digitale';

  @override
  String get confirmationDeconnexion =>
      'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get version => 'Sahhti v1.0.0 · صحتي';

  @override
  String get erreurConnexion => 'Numéro ou code PIN incorrect.';

  @override
  String get erreurReseau => 'Vérifiez votre connexion.';

  @override
  String get erreurGenerale => 'Une erreur est survenue. Réessayez.';

  @override
  String get connexionFaible => 'Connexion lente. Vérifiez votre réseau.';

  @override
  String get profilIntrouvable => 'Profil patient introuvable.';

  @override
  String get aucunMessageEnvPremier =>
      'Aucun message. Commencez une nouvelle conversation !';

  @override
  String get rdv => 'RDV';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get prochainsRdv => 'Prochains Rendez-vous';

  @override
  String get voirTout => 'Voir tout';

  @override
  String get aucunRdvTrouve => 'Aucun rendez-vous trouvé';

  @override
  String get confirme => 'confirmed';

  @override
  String get pending => 'pending';

  @override
  String get cancelled => 'cancelled';

  @override
  String get aucunVaccinEnreg => 'Aucun vaccin enregistré';

  @override
  String get medGeneraliste => 'Médecin Généraliste';

  @override
  String get gynecologue => 'Gynécologue';

  @override
  String get dermatologue => 'Dermatologue';

  @override
  String get aucuneConsultation => 'Aucune consultation enregistrée';

  @override
  String aucunRdvEn(String specialite) {
    return 'Aucun rendez-vous en $specialite';
  }

  @override
  String get at => 'à';

  @override
  String get momMedecin => 'Mon médecin';

  @override
  String get rdvConfirmeAvec => 'Rendez-vous confirmé avec';

  @override
  String get choisirUneDisponibilite =>
      'Veuillez sélectionner une disponibilité.';

  @override
  String get profilMisAJour => 'Profil mis à jour';

  @override
  String get codePinChangeAvecSucces => 'Code PIN changé avec succès';

  @override
  String mru(int montant) {
    return '$montant MRU';
  }

  @override
  String note(String valeur) {
    return '$valeur ⭐';
  }
}
