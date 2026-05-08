import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeDataLoaded extends HomeEvent {
  const HomeDataLoaded();
  @override
  List<Object> get props => [];
}

class PassportDataLoaded extends HomeEvent {
  final int patientId;
  const PassportDataLoaded({required this.patientId});
  @override
  List<Object> get props => [patientId];
}

class HomePinVisibiliyChange extends HomeEvent {}

class HomePinCopy extends HomeEvent {}

class DossierSpecialiteSelectionne extends HomeEvent {
  final String specialite;
  const DossierSpecialiteSelectionne({required this.specialite});
  @override
  List<Object> get props => [specialite];
}

class HomeRafraichi extends HomeEvent {
  const HomeRafraichi();
}

class DossierSpecialiteFermer extends HomeEvent {}
