import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
  @override
  List<Object> get props => [];
}

class ProfileChargeNav extends NavigationEvent {}

class NavigationOngletChange extends NavigationEvent {
  final int index;
  const NavigationOngletChange(this.index);
  @override
  List<Object> get props => [index];
}
