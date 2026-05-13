import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/l10n/build_context_l10n.dart';
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
    final t = context.l10n;
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
                        t.dossierMedical,
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
                              Text(t.specialites),
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
                          }, context),
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
    BuildContext context,
  ) {
    final t = context.l10n;
    IconData icone(String spec) {
      final s = spec.toLowerCase();
      switch (s) {
        case "cardiologue":
          return Icons.favorite;
        case "pediatre":
          return Icons.child_care;
        case "ophtalmologue":
          return Icons.visibility;
        case "neprologue":
          return Icons.water_drop;
      }
      return Icons.local_hospital;
    }

    Color couleur(String spec) {
      final s = spec.toLowerCase();
      switch (s) {
        case "cardiologue":
          return Colors.red;
        case "pediatre":
          return Colors.blue;
        case "ophtalmologue":
          return Colors.purple;
        case "neprologue":
          return Colors.green;
      }
      return AppColors.primary;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: stats.isEmpty
          ? Text(t.aucuneConsultation)
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
                              icone(stat.specialite),
                              color: couleur(stat.specialite),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(switch (stat.specialite.toLowerCase()) {
                            "cardiologue" => t.cardiologue,
                            "pédiatre" => t.pediatre,
                            "ophtalmologue" => t.ophtalmologue,
                            "neprologue" => t.neprologue,
                            "médecin généraliste" => t.medGeneraliste,
                            "dermatologue" => t.dermatologue,
                            "gynécologue" => t.gynecologue,
                            _ => stat.specialite,
                          }),
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
    final t = context.l10n;
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
            children: [
              Icon(Icons.bar_chart, size: 18, color: Colors.yellow),
              SizedBox(width: 8),
              Text(
                t.suivisIndicateurs,
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
                Text(
                  t.poidsActuel,
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

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Row(
      children: [
        Icon(Icons.vaccines, size: 18, color: Colors.grey),
        SizedBox(width: 8),
        Text(
          t.carnetVaccination,
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
    final t = context.l10n;
    if (state.vitals.isEmpty) {
      return _SectionCard(
        icon: Icons.bar_chart,
        iconColor: Colors.amber,
        title: t.suivisIndicateurs,
        child: Text(
          t.aucunIndicateurEnregistre,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return _SectionCard(
      icon: Icons.bar_chart,
      iconColor: Colors.amber,
      title: t.suivisIndicateurs,
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

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final config = {
      'heart_rate': (
        label: t.heartRate,
        icon: Icons.favorite,
        color: Color(0xFFE53935),
        unite: 'bpm',
        min: 60.0,
        max: 100.0,
      ),
      'blood_pressure': (
        label: t.bloodPressure,
        icon: Icons.show_chart,
        color: Color(0xFF1565C0),
        unite: 'mmHg',
        min: 90.0,
        max: 140.0,
      ),
      'temperature': (
        label: t.temperature,
        icon: Icons.thermostat,
        color: Color(0xFFE65100),
        unite: '°C',
        min: 36.0,
        max: 38.0,
      ),
      'weight': (
        label: t.weight,
        icon: Icons.monitor_weight,
        color: Color(0xFF2E7D32),
        unite: 'kg',
        min: 0.0,
        max: 150.0,
      ),
      'oxygen_saturation': (
        label: t.oxygenSaturation,
        icon: Icons.air,
        color: Color(0xFF00838F),
        unite: '%',
        min: 95.0,
        max: 100.0,
      ),
    };
    final cfg = config[type];
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
    final t = context.l10n;
    return _SectionCard(
      icon: Icons.vaccines,
      iconColor: Colors.grey,
      title: t.carnetVaccination,
      child: vaccinations.isEmpty
          ? Text(t.aucunVaccinEnreg, style: TextStyle(color: Colors.grey))
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
