import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClavierPin extends StatelessWidget {
  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final bool loading;

  const ClavierPin({
    required this.onDigit,
    required this.onDelete,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(
            color: Colors.white, strokeWidth: 2),
      );
    }

    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: rows.map((row) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((k) {
              if (k.isEmpty) return const SizedBox(width: 72, height: 72);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  if (k == '⌫') onDelete(); else onDigit(k);
                },
                child: Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: k == '⌫'
                        ? const Icon(Icons.backspace_outlined,
                            color: Colors.white, size: 22)
                        : Text(k, style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                  ),
                ),
              );
            }).toList(),
          ),
        )).toList(),
      ),
    );
  }
}