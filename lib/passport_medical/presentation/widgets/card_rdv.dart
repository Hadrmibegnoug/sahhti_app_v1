import 'package:flutter/material.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import '../../../l10n/build_context_l10n.dart';
import '../../data/models/data_medical/rdv_detail_model.dart';
import '../bloc/home_bloc/home_state.dart';

class CardRdv extends StatelessWidget {
  const CardRdv({super.key, required this.state});

  final HomeLoaded state;

  String _traduireSpecialite(t, String specialite) {
    final s = specialite.toLowerCase();
    if (s == 'cardiologue') return t.cardiologue;
    if (s == 'pediatre' || s == 'pédiatre') return t.pediatre;
    if (s == 'ophtalmologue') return t.ophtalmologue;
    if (s == 'neprologue') return t.neprologue;
    if (s == 'dermatologue') return t.dermatologue;
    if (s == 'Médecin Généraliste') return t.medGeneraliste;
    if (s == 'Gynécologue') return t.gynecologue;
    return specialite;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    List<RdvDetailModel> rdv = state.mesRendezVous;
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
                        Text(t.prochainsRdv, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      label: Text(t.voirTout),
                      icon: Icon(Icons.turn_right),
                    ),
                  ],
                ),
                Divider(color: AppColors.cardShadow, height: 20),
                rdv.isEmpty
                    ? Center(child: Text(t.aucunRdvTrouve))
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
                                  _traduireSpecialite(t, e.medecinSpecialite),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${e.appointmentDate.toLocal().toString().split(' ')[0]} ${t.at} ${e.startTime.hour.toString()}:${e.startTime.minute.toString().padLeft(2, '0')}',
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
                                switch (e.status) {
                                  "confirmed" => t.confirme,
                                  "pending" => t.pending,
                                  "cancelled" => t.cancelled,
                                  _ => e.status,
                                },
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
