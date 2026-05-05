import 'package:equatable/equatable.dart';

class SpecialitStatModel extends Equatable {
  final String specialite;
  final int nbRdv;

  const SpecialitStatModel({required this.specialite, required this.nbRdv});

  SpecialitStatModel copyWith({String? specialite, int? nbRdv}) {
    return SpecialitStatModel(
      specialite: specialite ?? this.specialite,
      nbRdv: nbRdv ?? this.nbRdv,
    );
  }

  @override
  List<Object?> get props => [specialite, nbRdv];
}
