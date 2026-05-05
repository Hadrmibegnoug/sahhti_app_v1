import 'package:equatable/equatable.dart';

class DoctorsModel extends Equatable {
  final int doctorId;
  final String firstName;
  final String lastName;
  final String specialty;
  final String city;
  final String bio;
  final double consultationFee;
  final double rating;
  final String imageUrl;

  const DoctorsModel({
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.city,
    required this.bio,
    required this.rating,
    required this.imageUrl,
    required this.consultationFee,
  });

  String get nomComplet => "Dr. $firstName $lastName";

  factory DoctorsModel.fromJson(Map<String, dynamic> json) {
    return DoctorsModel(
      doctorId: json["doctor_id"],
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      specialty: json["specialty"] as String,
      city: json["city"] as String,
      bio: json["bio"] as String,
      consultationFee: (json["consultation_fee"] as num).toDouble(),
      rating: (json["rating"] as num).toDouble(),
      imageUrl: json["photo_url"] as String? ?? "",
    );
  }

  @override
  List<Object?> get props => [
    doctorId,
    firstName,
    lastName,
    specialty,
    bio,
    consultationFee,
    rating,
    imageUrl,
  ];
}
