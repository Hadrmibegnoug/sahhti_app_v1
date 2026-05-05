import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_state.dart';
import 'package:sahha_pass/passport_medical/presentation/widgets/custom_card_patient.dart';

class PassportMedical extends StatelessWidget {
  const PassportMedical({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صحتي Passeport"),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (_) =>
                    BlocProvider.value(value: context.read<HomeBloc>()),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) {
            return Center(child: CircularProgressIndicator());
          }
          final patient = state.patientModel;
          final allergie = state.patientAllergiesModel;
          return Column(
            children: [
              CustomCardPatient(
                nomComplet: '${patient.lastName} ${patient.firstName}',
                NNI: patient.nni,
                groupeSanguin: patient.bloodType,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Row(
                  children: [
                    customButton("Télécharger PDF", Icons.download),
                    Spacer(),
                    customButton("Partager", Icons.share),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  border: BoxBorder.all(color: AppColors.error, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.language),
                    SizedBox(width: 5),
                    Text(
                      "Allergies: ",
                      style: TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                    SizedBox(width: 10),
                    if (allergie.isNotEmpty)
                      ...allergie.map((elm) {
                        return Row(
                          children: [
                            customAllergie(elm.allergen),
                            SizedBox(width: 5),
                          ],
                        );
                      })
                    else
                      SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: [
                    customCardInfo(
                      context,
                      "GROUPE SANGUIN",
                      patient.bloodType,
                      Icons.water_drop,
                      AppColors.error,
                      null,
                    ),
                    customCardInfo(
                      context,
                      "MEDECIN TRAITANT:",
                      patient.treatingDoctorId,
                      Icons.local_hospital,
                      AppColors.success,
                      null,
                    ),
                    customCardInfo(
                      context,
                      "CONTACT D'URGENCE",
                      "",
                      Icons.phone,
                      AppColors.notfication,
                      null,
                    ),
                    customCardInfo(
                      context,
                      "ALLERGIES",
                      "",
                      Icons.warning,
                      AppColors.error,
                      allergie.map((e) => e.allergen).toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container customCardInfo(
    BuildContext context,
    String title,
    String info,
    IconData icon,
    Color color,
    List<String>? allergies,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.2,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            const Color.fromARGB(255, 255, 255, 255).withOpacity(0.54),
            const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, color: color, size: 40),
          Text(
            //"CONTACT D'URGENCE",
            title,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          Text(
            //"Ahmed El Alami +212 6 12345678",
            info,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (allergies != null && allergies.isNotEmpty)
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: allergies.map((elm) => customAllergie(elm)).toList(),
            ),
        ],
      ),
    );
  }

  Container customAllergie(String title) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.background,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget customButton(String title, IconData icon) {
    return TextButton.icon(
      onPressed: () {},
      label: Text(title),
      icon: Icon(icon),
    );
  }
}
