import 'package:flutter/material.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/appointments.dart';
import '../bloc/home_bloc/home_state.dart';

class CardRdv extends StatelessWidget {
  const CardRdv({super.key, required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    List<AppointmentsModel> rdv = state.mesRendezVous;
    return Container(
      width: double.infinity,
      //height: MediaQuery.of(context).size.height * 0.35,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Card(
        color: AppColors.background,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: AppColors.error),
                        //SizedBox(width: 5),
                        Text("PROCHAINS RENDEZ VOUS"),
                      ],
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      label: Text("Voir tout"),
                      icon: Icon(Icons.turn_right),
                    ),
                  ],
                ),
                Divider(color: AppColors.cardShadow, height: 20),
                rdv.isEmpty
                    ? Center(child: Text("Aucun rendez vous trouvé"))
                    : SizedBox.shrink(),
                ...rdv.map((e) {
                  final statut = e.status;
                  final Color statusColor = switch (statut) {
                    "confirmed" => AppColors.primary,
                    "pending" => const Color.fromARGB(255, 201, 99, 4),
                    "cancelled" => AppColors.error,
                    _ => Colors.blue,
                  };
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        splashColor: AppColors.border,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.type,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${e.appointmentDate.year}-${e.appointmentDate.month}-${e.appointmentDate.day} ${e.startTime}',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                e.status,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
