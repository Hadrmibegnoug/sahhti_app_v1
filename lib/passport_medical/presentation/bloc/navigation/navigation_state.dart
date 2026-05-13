import 'package:equatable/equatable.dart';

import '../../../data/models/profile/profile_model.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationChargement extends NavigationState {}

class NavigationActive extends NavigationState {
  final int indexActuel;
  const NavigationActive({required this.indexActuel});
  @override
  List<Object> get props => [indexActuel];
}

class ProfileLoadedNav extends NavigationState {
  final ProfileModel profile;
  const ProfileLoadedNav(this.profile);

  ProfileLoadedNav copyWith({ProfileModel? profile}) =>
      ProfileLoadedNav(profile ?? this.profile);

  @override List<Object> get props => [profile];
}

class NavigationErreur extends NavigationState {
  final String message;
  const NavigationErreur(this.message);
  @override
  List<Object> get props => [message];
}
