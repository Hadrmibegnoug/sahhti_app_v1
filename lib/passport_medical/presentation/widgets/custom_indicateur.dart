import 'package:flutter/material.dart';

class CustomIndicateur extends StatelessWidget {
  const CustomIndicateur({
    super.key,
    required this.number,
    required this.title,
    required this.containerColor,
    required this.textColor,
  });

  final int number;
  final String title;
  final Color containerColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerColor,
      ),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
