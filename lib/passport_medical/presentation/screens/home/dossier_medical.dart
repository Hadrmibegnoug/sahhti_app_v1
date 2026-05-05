import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vaccinations.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/patient_vitals.dart';
import 'package:sahha_pass/passport_medical/data/models/data_medical/specialit_stat_model.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_state.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/home/specialite_detail_page.dart';

class DossierMedical extends StatelessWidget {
  const DossierMedical({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صحتي Passeport"),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.primary,
                          thickness: 1,
                          indent: 20,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                        "DOSSIER MÉDICAL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.primary,
                          thickness: 1,
                          indent: 10,
                          endIndent: 20,
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.health_and_safety,
                                color: AppColors.primary,
                              ),
                              Text("SPÉCIALITÉS"),
                            ],
                          ),
                          SizedBox(height: 15),
                          customCardSpecialte(state.statsSpecialits, (spec) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<HomeBloc>()
                                    ..add(
                                      DossierSpecialiteSelectionne(
                                        specialite: spec,
                                      ),
                                    ),
                                  child: SpecialiteDetailPage(specialite: spec),
                                ),
                              ),
                            );
                          }),
                          // customCardSpecialte(
                          //   "Général",
                          //   "35",
                          //   Icons.local_hospital,
                          //   Colors.blue[200]!,
                          // ),
                          // Divider(color: AppColors.cardShadow, height: 20),
                          // customCardSpecialte(
                          //   "Cardiologie",
                          //   "1",
                          //   Icons.favorite,
                          //   AppColors.error,
                          // ),
                          // Divider(color: AppColors.cardShadow, height: 20),
                          // customCardSpecialte(
                          //   "Dermatologie",
                          //   "2",
                          //   Icons.face,
                          //   Colors.orange[200]!,
                          // ),
                          // Divider(color: AppColors.cardShadow, height: 20),
                          // customCardSpecialte(
                          //   "Néprologie",
                          //   "3",
                          //   Icons.local_hospital,
                          //   Colors.green[200]!,
                          // ),
                          // Divider(color: AppColors.cardShadow, height: 20),
                          // customCardSpecialte(
                          //   "Ophtalmologie",
                          //   "4",
                          //   Icons.visibility,
                          //   Colors.purple[200]!,
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  //IndicatorCard(),
                  _SuiviIndicateurs(state: state),
                  SizedBox(height: 15),
                  _CarnetVaccination(vaccinations: state.vaccinations),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget customCardSpecialte(
    final List<SpecialitStatModel> stats,
    final void Function(String) onSelectedSpecialite,
  ) {
    IconData _icone(String spec) {
      switch (spec.toLowerCase()) {
        case 'cardiologue':
          return Icons.favorite;
        case 'pédiatre':
          return Icons.child_care;
        case 'ophtalmologue':
          return Icons.visibility;
        case 'néprologue':
          return Icons.water_drop;
        default:
          return Icons.local_hospital;
      }
    }

    Color _couleur(String spec) {
      switch (spec.toLowerCase()) {
        case 'cardiologue':
          return Colors.red;
        case 'pédiatre':
          return Colors.blue;
        case 'ophtalmologue':
          return Colors.purple;
        case 'néprologue':
          return Colors.green;
        default:
          return AppColors.primary;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: stats.isEmpty
          ? Text("Aucune Consultation")
          : Column(
              children: stats.asMap().entries.map((entry) {
                final i = entry.key;
                final stat = entry.value;
                return Column(
                  children: [
                    InkWell(
                      onTap: () => onSelectedSpecialite(stat.specialite),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              _icone(stat.specialite),
                              color: _couleur(stat.specialite),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(stat.specialite),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.4),
                            maxRadius: 15,
                            child: Text(
                              stat.nbRdv.toString(),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    if (i < stats.length - 1)
                      Divider(color: Colors.grey.shade100, height: 8),
                  ],
                );
              }).toList(),
            ),
    );
  }
}

class IndicatorCard extends StatelessWidget {
  const IndicatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Row(
            children: const [
              Icon(Icons.bar_chart, size: 18, color: Colors.yellow),
              SizedBox(width: 8),
              Text(
                "SUIVI DES INDICATEURS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// INNER CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  "Poids Actuel",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                /// VALUE
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "59.2",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: " kg",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                /// CHANGE
                const Text(
                  "+1.2 kg",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                /// GRAPH
                SizedBox(
                  height: 50,
                  child: CustomPaint(
                    painter: LineChartPainter(),
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final path = Path();

    // Points simulés (tu peux connecter à des vraies données)
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.25, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.65),
      Offset(size.width * 0.75, size.height * 0.55),
      Offset(size.width, size.height * 0.5),
    ];

    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw last point
    canvas.drawCircle(points.last, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// class VaccinationCard extends StatelessWidget {
//   const VaccinationCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Header(),
//           SizedBox(height: 16),
//           VaccineItem(
//             title: "Fièvre Jaune",
//             date: "1/1 - 2019",
//             progress: 1.0,
//             status: "Complet",
//             isComplete: true,
//           ),
//           SizedBox(height: 12),
//           VaccineItem(
//             title: "Tétanos",
//             date: "1/3 - 2014",
//             progress: 0.5,
//             status: "Rappel",
//             isComplete: false,
//           ),
//         ],
//       ),
//     );
//   }
// }

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.vaccines, size: 18, color: Colors.grey),
        SizedBox(width: 8),
        Text(
          "CARNET DE VACCINATION",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Section card wrapper ──────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// Dans dossier_medical.dart — remplacer _SuiviPoids par _SuiviIndicateurs

class _SuiviIndicateurs extends StatelessWidget {
  final HomeLoaded state;
  const _SuiviIndicateurs({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.vitals.isEmpty) {
      return _SectionCard(
        icon: Icons.bar_chart,
        iconColor: Colors.amber,
        title: 'SUIVI DES INDICATEURS',
        child: const Text(
          'Aucun indicateur enregistré',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return _SectionCard(
      icon: Icons.bar_chart,
      iconColor: Colors.amber,
      title: 'SUIVI DES INDICATEURS',
      child: Column(
        children: state.typesDisponibles
            .map(
              (type) => _IndicateurCard(
                type: type,
                vitals: state.vitalsByType[type] ?? [],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _IndicateurCard extends StatelessWidget {
  final String type;
  final List<PatientVitalsModel> vitals;
  const _IndicateurCard({required this.type, required this.vitals});

  // Config par type de vital
  static const _config = {
    'heart_rate': (
      label: 'Fréquence cardiaque',
      icon: Icons.favorite,
      color: Color(0xFFE53935),
      unite: 'bpm',
      min: 60.0,
      max: 100.0,
    ),
    'blood_pressure': (
      label: 'Tension artérielle',
      icon: Icons.show_chart,
      color: Color(0xFF1565C0),
      unite: 'mmHg',
      min: 90.0,
      max: 140.0,
    ),
    'temperature': (
      label: 'Température',
      icon: Icons.thermostat,
      color: Color(0xFFE65100),
      unite: '°C',
      min: 36.0,
      max: 38.0,
    ),
    'weight': (
      label: 'Poids',
      icon: Icons.monitor_weight,
      color: Color(0xFF2E7D32),
      unite: 'kg',
      min: 0.0,
      max: 150.0,
    ),
    'oxygen_saturation': (
      label: 'Saturation O₂',
      icon: Icons.air,
      color: Color(0xFF00838F),
      unite: '%',
      min: 95.0,
      max: 100.0,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cfg = _config[type];
    final label = cfg?.label ?? type;
    final icon = cfg?.icon ?? Icons.monitor_heart;
    final color = cfg?.color ?? AppColors.primary;
    final unite = vitals.isNotEmpty ? vitals.last.unit : (cfg?.unite ?? '');
    final dernier = vitals.isNotEmpty ? vitals.last.value : null;
    final valeurs = vitals.map((v) => v.value).toList();

    // Variation
    String? variation;
    Color variationColor = Colors.green;
    if (vitals.length >= 2) {
      final diff = vitals.last.value - vitals[vitals.length - 2].value;
      variation = diff >= 0
          ? '+${diff.toStringAsFixed(1)} $unite'
          : '${diff.toStringAsFixed(1)} $unite';
      variationColor = diff > 0 ? Colors.orange : Colors.green;
    }

    // Indicateur normal / anormal
    final isNormal = dernier == null
        ? true
        : dernier >= (cfg?.min ?? 0) && dernier <= (cfg?.max ?? 999);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête ─────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              // Badge normal / anormal
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isNormal
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isNormal ? 'Normal' : 'Anormal',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: isNormal ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Valeur + variation ───────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              dernier == null
                  ? Text(
                      '—',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    )
                  : RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: dernier.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          TextSpan(
                            text: ' $unite',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
              const Spacer(),
              if (variation != null)
                Text(
                  variation,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: variationColor,
                  ),
                ),
            ],
          ),

          // ── Courbe si plusieurs mesures ──────────────────
          if (valeurs.length >= 2) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: CustomPaint(
                painter: _VitalChartPainter(valeurs: valeurs, color: color),
                child: const SizedBox.expand(),
              ),
            ),
          ],

          // ── Date dernière mesure ─────────────────────────
          if (vitals.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Dernière mesure : ${_formatDate(vitals.last.recordedAt)}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }
}

// ── Courbe générique pour n'importe quel vital ─────────────────────
class _VitalChartPainter extends CustomPainter {
  final List<num> valeurs;
  final Color color;
  const _VitalChartPainter({required this.valeurs, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (valeurs.length < 2) return;

    final min = valeurs.reduce((a, b) => a < b ? a : b);
    final max = valeurs.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1.0 : max - min;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final points = valeurs.asMap().entries.map((e) {
      final x = e.key / (valeurs.length - 1) * size.width;
      final y = size.height - ((e.value - min) / range) * size.height;
      return Offset(x, y.clamp(2.0, size.height - 2));
    }).toList();

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Point final
    canvas.drawCircle(
      points.last,
      4,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _VitalChartPainter old) =>
      old.valeurs != valeurs;
}

// ── Carnet vaccination ────────────────────────────────────────────
class _CarnetVaccination extends StatelessWidget {
  final List<PatientVaccinationsModel> vaccinations;
  const _CarnetVaccination({required this.vaccinations});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.vaccines,
      iconColor: Colors.grey,
      title: 'CARNET DE VACCINATION',
      child: vaccinations.isEmpty
          ? const Text(
              'Aucun vaccin enregistré',
              style: TextStyle(color: Colors.grey),
            )
          : Column(
              children: vaccinations
                  .map((v) => _VaccineItem(vaccin: v))
                  .toList(),
            ),
    );
  }
}

class _VaccineItem extends StatelessWidget {
  final PatientVaccinationsModel vaccin;
  const _VaccineItem({required this.vaccin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: vaccin.estComplet
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              vaccin.estComplet ? Icons.check : Icons.warning,
              color: vaccin.estComplet ? Colors.green : Colors.orange,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vaccin.vaccineName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: vaccin.estComplet
                            ? Colors.green.withOpacity(0.12)
                            : Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        vaccin.estComplet ? 'Complet' : 'Rappel',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: vaccin.estComplet
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${vaccin.dosesReceived}/${vaccin.dosesRequired} dose'
                  '${vaccin.dosesRequired > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: vaccin.progression.clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(
                      vaccin.estComplet ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class VaccineItem extends StatelessWidget {
//   final String title;
//   final String date;
//   final double progress;
//   final String status;
//   final bool isComplete;

//   const VaccineItem({
//     super.key,
//     required this.title,
//     required this.date,
//     required this.progress,
//     required this.status,
//     required this.isComplete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         /// ICON
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: isComplete
//                 ? Colors.green.withOpacity(0.1)
//                 : Colors.orange.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             isComplete ? Icons.check : Icons.warning,
//             color: isComplete ? Colors.green : Colors.orange,
//           ),
//         ),

//         const SizedBox(width: 12),

//         /// CONTENT
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// TITLE + STATUS
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isComplete
//                           ? Colors.green.withOpacity(0.15)
//                           : Colors.orange.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       status,
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: isComplete ? Colors.green : Colors.orange,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 4),

//               /// DAaTE
//               Text(
//                 date,
//                 style: const TextStyle(fontSize: 11, color: Colors.grey),
//               ),

//               const SizedBox(height: 8),

//               /// PROGRESS BAR
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: LinearProgressIndicator(
//                   value: progress,
//                   minHeight: 4,
//                   backgroundColor: Colors.grey.shade300,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     isComplete ? Colors.green : Colors.orange,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
