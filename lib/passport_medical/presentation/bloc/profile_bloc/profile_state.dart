import 'package:equatable/equatable.dart';

import '../../../data/models/profile/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override List<Object?> get props => [];
}

class ProfileInitial      extends ProfileState {}
class ProfileChargement   extends ProfileState {}
class ProfileDeconnecte   extends ProfileState {} // ← déclenche navigation
class ProfilePinEnCours   extends ProfileState {}
class ProfilePinSucces    extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  const ProfileLoaded(this.profile);

  ProfileLoaded copyWith({ProfileModel? profile}) =>
      ProfileLoaded(profile ?? this.profile);

  @override List<Object> get props => [profile];
}

class ProfileMisAJourSucces extends ProfileState {
  final ProfileModel profile;
  const ProfileMisAJourSucces(this.profile);
  @override List<Object> get props => [profile];
}

class ProfileErreur extends ProfileState {
  final String message;
  const ProfileErreur(this.message);
  @override List<Object> get props => [message];
}