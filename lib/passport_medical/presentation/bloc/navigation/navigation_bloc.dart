import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationActive(indexActuel: 0)) {
    on<NavigationOngletChange>(_ongletChange);
  }

  void _ongletChange(
    NavigationOngletChange event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationActive(indexActuel: event.index));
  }
}
