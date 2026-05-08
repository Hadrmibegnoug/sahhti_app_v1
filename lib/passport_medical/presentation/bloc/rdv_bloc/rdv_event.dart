import 'package:equatable/equatable.dart';

abstract class RdvEvent extends Equatable {
  const RdvEvent();
  @override
  List<Object?> get props => [];
}

class RdvDataLoaded extends RdvEvent {
  const RdvDataLoaded();
  @override
  List<Object?> get props => [];
}

class RdvSelectionne extends RdvEvent {}

class RdvRafraichies extends RdvEvent {
  const RdvRafraichies();
  @override
  List<Object> get props => [];
}
