import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/home_bloc/home_state.dart';

class Ordonnance extends StatelessWidget {
  const Ordonnance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ordonnance"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) {
            return Center(child: CircularProgressIndicator());
          }
          final prescriptions = state.prescriptions;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                customContainer(
                  context,
                  MediaQuery.of(context).size.height * 0.3,
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.health_and_safety_outlined,
                            size: 30,
                            color: Colors.red,
                          ),
                          Text("ORDONNANCES ACTIVITES"),
                        ],
                      ),

                      SizedBox(height: 10),
                      ...prescriptions.map((prescription) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                medicament(
                                  prescription.status == 'completed'
                                      ? AppColors.primaryLight
                                      : AppColors.language,
                                  prescription.medicationName,
                                  '${prescription.dosage}, ${prescription.frequency}',
                                  prescription.status,
                                ),
                                Divider(
                                  color: AppColors.cardShadow,
                                  thickness: 2,
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                customContainer(
                  context,
                  MediaQuery.of(context).size.height * 0.5,
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.health_and_safety_sharp,
                            size: 30,
                            color: Colors.red,
                          ),
                          Text("EXAMENS & IMAGERIES"),
                          Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            label: Text("Ajouter"),
                            icon: Icon(Icons.add, size: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: GridView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bloodtype,
                                      size: 30,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Bilan sanguin",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 30,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Echographie abdominale",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 30,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Radiographie thoracique",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 30,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "IRM cérébrale",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container customContainer(BuildContext context, double height, Widget child) {
    return Container(
      width: double.infinity,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }

  Row medicament(Color color, String name, String dosage, String frequency) {
    return Row(
      children: [
        CircleAvatar(maxRadius: 8, backgroundColor: color.withOpacity(0.8)),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
            Text(
              dosage,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ],
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            frequency,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
