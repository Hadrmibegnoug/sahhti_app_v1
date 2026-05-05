import 'package:flutter/material.dart';
import 'package:sahha_pass/auth/presentation/login.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                "S'inscrire",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    customInput("Name", Icon(Icons.person)),
                    SizedBox(height: 20),
                    customInput("age", Icon(Icons.numbers)),
                    SizedBox(height: 20),
                    customInput("Date de Naissance", Icon(Icons.date_range)),
                    SizedBox(height: 20),
                    customInput("Sexe", Icon(Icons.male)),
                    SizedBox(height: 20),
                    customInput("Grouper Sanguin", Icon(Icons.water_drop)),
                    SizedBox(height: 20),
                    customInput("Allergies", Icon(Icons.help)),
                    SizedBox(height: 20),
                    customInput(
                      "Maladies Chroniques",
                      Icon(Icons.health_and_safety),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField customInput(String label, Widget icon) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.border,
        labelText: label,
        suffixIcon: icon,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
