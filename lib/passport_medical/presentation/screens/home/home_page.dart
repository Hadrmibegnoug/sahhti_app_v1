import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/data/datasources/home_datasource.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_contenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(HomeDatasource(Supabase.instance.client))
            ..add(HomeDataLoaded()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is HomeErreur) {
            return Center(child: Text(state.message));
          }
          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(HomeDataLoaded());
                await context.read<HomeBloc>().stream.firstWhere(
                  (s) => s is HomeLoaded || s is HomeErreur,
                );
              },
              child: HomeContenu(state: state),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
