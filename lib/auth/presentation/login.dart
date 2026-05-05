import 'package:flutter/material.dart';
import 'package:sahha_pass/auth/presentation/register.dart';
import 'package:sahha_pass/core/constants/app_colors.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/tabscreen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  // width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,

                  //alignment: Alignment.topCenter,
                ),
                Column(
                  children: [
                    customInput(
                      "tél",
                      Icon(
                        Icons.phone_android_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    customInput(
                      "mot de passe",
                      Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => Tabscreen()),
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
                        "Se connecter",
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => Register()),
                        );
                      },
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
