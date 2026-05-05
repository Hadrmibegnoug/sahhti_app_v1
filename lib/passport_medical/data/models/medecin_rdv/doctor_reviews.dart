import 'package:equatable/equatable.dart';

class DoctorReviewsModel extends Equatable {
  final String doctorId;
  final String patientId;
  final String rating;
  final String comment;

  const DoctorReviewsModel({
    required this.doctorId,
    required this.patientId, 
    required this.rating, 
    required this.comment
  });

  @override
  List<Object?> get props => [
    doctorId, 
    patientId, 
    rating, 
    comment
  ];
}
