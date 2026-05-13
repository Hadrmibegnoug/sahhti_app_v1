import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/profile/profile.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/build_context_l10n.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_event.dart';
import '../../bloc/home_bloc/home_state.dart';
import '../../widgets/card_rdv.dart';
import '../../widgets/custom_card_pin.dart';
import '../../widgets/custom_indicateur.dart';
import 'dossier_medical.dart';
import 'ordonnance.dart';
import 'passport_medical.dart';

class HomeContenu extends StatelessWidget {
  final HomeLoaded state;
  const HomeContenu({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Row(
            children: [
              Expanded(
                child: infoSeparer(
                  context,
                  t.passport,
                  PassportMedical(),
                  Icons.medical_services,
                ),
              ),
              Expanded(
                child: infoSeparer(
                  context,
                  t.dossier,
                  DossierMedical(),
                  Icons.folder_shared,
                ),
              ),
              Expanded(
                child: infoSeparer(
                  context,
                  t.ordonnances,
                  Ordonnance(),
                  Icons.description,
                ),
              ),
            ],
          ),
          CustomCardPin(state: state),
          SizedBox(height: 5),
          CardRdv(state: state),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: CustomIndicateur(
                  number: state.nbOrdonnances,
                  title: t.ordonnances,
                  containerColor: AppColors.border,
                  textColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: CustomIndicateur(
                  number: state.nbVaccins,
                  title: t.vaccins,
                  containerColor: AppColors.border,
                  textColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: CustomIndicateur(
                  number: state.nbConsultations,
                  title: t.prescriptions,
                  containerColor: AppColors.border,
                  textColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: CustomIndicateur(
                  number: state.nbAllergies,
                  title: t.allergies,
                  containerColor: AppColors.error.withOpacity(0.5),
                  textColor: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget infoSeparer(
  BuildContext context,
  String title,
  Widget page,
  IconData icon,
) {
  return TextButton.icon(
    onPressed: () {
      final homeBloc = context.read<HomeBloc>();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(value: homeBloc, child: page),
        ),
      );
    },
    label: Text(
      title,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
    icon: Icon(icon),
  );
}
