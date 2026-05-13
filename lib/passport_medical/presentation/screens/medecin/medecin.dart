import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/data/datasources/medecin_datasource.dart';
import 'package:sahha_pass/passport_medical/data/models/medecin_rdv/doctors.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/medecin_bloc/medecin_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/medecin_bloc/medecin_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/medecin_bloc/medecin_state.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/medecin/medecin_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../l10n/build_context_l10n.dart';

class MedecinListPage extends StatelessWidget {
  const MedecinListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedecinBloc(MedecinDatasource(Supabase.instance.client))
            ..add(MedecinPageOuverte()),
      child: _Medecin(),
    );
  }
}

class SpecialiteItem {
  final String key;
  final String label;

  const SpecialiteItem({required this.key, required this.label});
}

class _Medecin extends StatelessWidget {
  const _Medecin();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final specialites = [
      SpecialiteItem(key: 'Tous', label: t.tous),
      SpecialiteItem(key: 'Cardiologue', label: t.cardiologue),
      SpecialiteItem(key: 'Médecin Généraliste', label: t.medGeneraliste),
      SpecialiteItem(key: 'Dermatologue', label: t.dermatologue),
      SpecialiteItem(key: 'Gynécologue', label: t.gynecologue),
      SpecialiteItem(key: 'Pédiatre', label: t.pediatre),
      SpecialiteItem(key: 'Ophtalmologue', label: t.ophtalmologue),
    ];
    return Scaffold(
      body: BlocBuilder<MedecinBloc, MedecinState>(
        builder: (context, state) {
          final medecins = state is MedecinLoaded
              ? state.medecinsFiltres
              : <DoctorsModel>[];

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MedecinBloc>().add(MedecinPageOuverte());
              await context.read<MedecinBloc>().stream.firstWhere(
                (s) => s is MedecinLoaded || s is MedecinError,
              );
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TextFormField(
                      onChanged: (query) => context.read<MedecinBloc>().add(
                        MedecinSearchChanged(query),
                      ),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.location_on),
                        labelText: t.momMedecin,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: BlocBuilder<MedecinBloc, MedecinState>(
                      builder: (context, state) {
                        final active = state is MedecinLoaded
                            ? state.specialityActive
                            : null;
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: specialites.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final spec = specialites[index];
                            final isTous = spec.key == 'Tous';
                            final isActivie = isTous
                                ? active == null
                                : active == spec.key;
                            return ChoiceChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              label: Text(spec.label),
                              selected: isActivie,
                              onSelected: (_) =>
                                  context.read<MedecinBloc>().add(
                                    SpecialitySelected(
                                      isTous ? null : spec.key,
                                    ),
                                  ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 10)),

                if (state is MedecinLoading)
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),

                if (state is MedecinError)
                  SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  ),

                if (state is MedecinLoaded)
                  medecins.isEmpty
                      ? SliverFillRemaining(
                          child: Center(child: Text(t.aucunMedecinTrouve)),
                        )
                      : SliverList(
                          //shrinkWrap: true,
                          //padding: EdgeInsets.symmetric(horizontal: 16),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: () async => context
                                    .read<MedecinBloc>()
                                    .add(const MedecinsRefraichies()),
                                child: _customDoctorCard(
                                  doctorsModel: medecins[index],
                                ),
                              ),
                            ),
                            childCount: medecins.length,
                          ),
                        ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _customDoctorCard extends StatelessWidget {
  final DoctorsModel doctorsModel;
  const _customDoctorCard({required this.doctorsModel});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      //height: MediaQuery.of(context).size.height * 0.17,
      constraints: BoxConstraints(minHeight: 120),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.background,
            child: ClipOval(
              child: Image.network(
                doctorsModel.imageUrl,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  doctorsModel.nomComplet,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        doctorsModel.specialty,
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 2),
                        Text(
                          doctorsModel.city,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 10, color: Colors.amber),
                    SizedBox(width: 2),
                    Text(
                      doctorsModel.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Flexible(
                        child: Text(
                          doctorsModel.bio,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    final medecinBloc = context.read<MedecinBloc>();
                    final result = Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: medecinBloc,
                          child: MedecinDetailPage(doctor: doctorsModel),
                        ),
                      ),
                    );
                    if (result == true) {
                      context.read<MedecinBloc>().add(MedecinPageOuverte());
                    }
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      t.prendreRDV,
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
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
