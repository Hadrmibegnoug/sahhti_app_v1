import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';

class ChampTelephone extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget icon;
  final String? hintText;
  final TextInputType? keyboard;
  final bool obscureText;
  const ChampTelephone({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText,
    this.keyboard,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // ── Champ numéro ────────────────────────────
          Expanded(
            child: TextFormField(
              style: TextStyle(color: Colors.black),
              controller: controller,
              keyboardType: keyboard,
              obscureText: obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.border,
                labelText: label,
                suffixIcon: icon,
                hintText: hintText,
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
            ),
          ),
        ],
      ),
    );
  }
}
