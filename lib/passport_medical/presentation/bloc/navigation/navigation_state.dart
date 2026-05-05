import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
  @override
  List<Object> get props => [];
}

class NavigationActive extends NavigationState {
  final int indexActuel;
  const NavigationActive({required this.indexActuel});
  @override
  List<Object> get props => [indexActuel];
}
