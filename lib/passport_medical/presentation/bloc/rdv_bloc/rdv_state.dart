import 'package:equatable/equatable.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/rdv_detail_model.dart';

abstract class RdvState extends Equatable {
  const RdvState();
  @override
  List<Object?> get props => [];
}

class RdvInitialState extends RdvState {}

class RdvLoading extends RdvState {}

class RdvLoaded extends RdvState {
  final List<RdvDetailModel> tousLesRdv;
  const RdvLoaded({required this.tousLesRdv});
  RdvLoaded copyWith() {
    return RdvLoaded(tousLesRdv: tousLesRdv);
  }

  @override
  List<Object?> get props => [tousLesRdv];
}

class RdvErreur extends RdvState {
  final String message;
  const RdvErreur({required this.message});
  @override
  List<Object?> get props => [message];
}
