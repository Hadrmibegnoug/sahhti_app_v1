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

class MedecinListPage extends StatelessWidget {
  const MedecinListPage({super.key});

  static const _specialites = [
    'Tous',
    'Cardiologue',
    'Médecin Généraliste',
    'Dermatologue',
    'Gynécologue',
    'Pédiatre',
    'Ophtalmologie',
  ];
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

class _Medecin extends StatelessWidget {
  const _Medecin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MedecinBloc, MedecinState>(
        builder: (context, state) {
          //final active = state is MedecinLoaded ? state.specialityActive : null;
          final medecins = state is MedecinLoaded
              ? state.medecinsFiltres
              : <DoctorsModel>[];

          return CustomScrollView(
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
                      labelText: "Nom du médecin",
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
                        itemCount: MedecinListPage._specialites.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final spec = MedecinListPage._specialites[index];
                          final isTous = spec == 'Tous';
                          final isActivie = isTous
                              ? active == null
                              : active == spec;
                          return ChoiceChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            label: Text(spec),
                            selected: isActivie,
                            onSelected: (_) => context.read<MedecinBloc>().add(
                              SpecialitySelected(isTous ? null : spec),
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
                SliverFillRemaining(child: Center(child: Text(state.message))),

              if (state is MedecinLoaded)
                medecins.isEmpty
                    ? SliverFillRemaining(
                        child: Center(child: Text("Aucun Medecin Trouvé")),
                      )
                    : SliverList(
                        //shrinkWrap: true,
                        //padding: EdgeInsets.symmetric(horizontal: 16),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: _customDoctorCard(
                              doctorsModel: medecins[index],
                            ),
                          ),
                          childCount: medecins.length,
                        ),
                      ),
            ],
          );
        },
      ),
    );
  }

  // Container speciality_selected() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     decoration: BoxDecoration(
  //       color: AppColors.primary.withOpacity(0.3),
  //       borderRadius: BorderRadius.circular(25),
  //     ),
  //     child: Text(
  //       "Cardiologue",
  //       style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
}

class _customDoctorCard extends StatelessWidget {
  final DoctorsModel doctorsModel;
  const _customDoctorCard({required this.doctorsModel});

  @override
  Widget build(BuildContext context) {
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
                      "Prendre RDV",
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
