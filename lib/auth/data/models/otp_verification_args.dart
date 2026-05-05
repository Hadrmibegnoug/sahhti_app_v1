import 'registry_patient_model.dart';

class OtpVerificationArgs {
  final String               telephone;
  final String               pin;
  final RegistryPatientModel patient;

  const OtpVerificationArgs({
    required this.telephone,
    required this.pin,
    required this.patient,
  });
}