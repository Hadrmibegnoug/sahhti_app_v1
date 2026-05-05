import 'registry_patient_model.dart';

class RegisterPinArgs {
  final RegistryPatientModel patient;
  final String               telephone;

  const RegisterPinArgs({
    required this.patient,
    required this.telephone,
  });
}